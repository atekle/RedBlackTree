#!/usr/bin/ruby

class Node
    include Comparable

    @@red = 0
    @@black = 1

    attr_accessor :left
    attr_accessor :right
    attr_accessor :parent
    attr_accessor :color
    attr_reader :value

    def initialize(value)
        @value = value
    end

    def <=>(other)
        if @value < other.value
            -1
        elsif @value > other.value
            1
        else
            0
        end
    end

    def setRed
        @color = @@red
    end

    def setBlack
        @color = @@black
    end

    def red?
        @color == @@red
    end

    def black?
        @color == @@black
    end
end

class RedBlackTree
    def initialize
        @@nil = Node.new(nil)
        @@nil.left = @@nil
        @@nil.right = @@nil
        @@nil.parent = @@nil
        @@nil.setBlack
        @root = @@nil
    end

    def insert(value)
        x = @root
        y = @@nil
        z = Node.new(value)
        while x != @@nil
            y = x
            x = z < x ? x.left : x.right
        end
        z.parent = y
        if y == @@nil
            @root = z
        elsif z < y
            y.left = z
        else
            y.right = z
        end
        z.left = @@nil
        z.right = @@nil
        z.setRed
        while z.parent.red?
            if z.parent == z.parent.parent.left
                y = z.parent.parent.right
                if y.red?
                    y.setBlack
                    z.parent.setBlack
                    z.parent.parent.setRed
                    z = z.parent.parent
                else
                    if z == z.parent.right
                        z = z.parent
                        rotateLeft(z)
                    end
                    z.parent.setBlack
                    z.parent.parent.setRed
                    rotateRight(z.parent.parent)
                end
            else
                y = z.parent.parent.left
                if y.red?
                    y.setBlack
                    z.parent.setBlack
                    z.parent.parent.setRed
                    z = z.parent.parent
                else
                    if z == z.parent.left
                        z = z.parent
                        rotateRight(z)
                    end
                    z.parent.setBlack
                    z.parent.parent.setRed
                    rotateLeft(z.parent.parent)
                end
            end
        end
        @root.setBlack
    end

    def to_s
        walkInOrder(@root).to_s
    end

    private

    def rotateLeft(x)
        y = x.right
        x.right = y.left
        y.left.parent = x if y.left != @@nil
        y.parent = x.parent
        if x.parent == @@nil
            @root = y
        elsif x == x.parent.left
            x.parent.left = y
        else
            x.parent.right = y
        end
        y.left = x
        x.parent = y
    end

    def rotateRight(x)
        y = x.left
        x.left = y.right
        y.right.parent = x if y.right != @@nil
        if x.parent == @@nil
            @root = y
        elsif x == x.parent.left
            x.parent.left = y
        else
            x.parent.right = y
        end
        y.right = x
        x.parent = y
    end

    def walkInOrder(x)
        data = []
        if x != @@nil
            data.concat(walkInOrder(x.left))
            data << x.value
            data.concat(walkInOrder(x.right))
        end
        data
    end
end

rbt = RedBlackTree.new
puts rbt

for i in [7, 0, 2, 4, 6, 1, 3, 5]
    puts i
    rbt.insert(i)
    puts rbt
end
