require 'WaneEngine.src.data'
local WaneBoard = require 'WaneEngine.src.board'


function love.load()
    init_hash()
    WaneBoard:init()

    orientation = 1 -- 1 for white perspective, -1 for black


    held = {
        piece = EMPTY,
        color = EMPTY,
        origin = nil
    }

    chess = love.graphics.newImage("chess.png")
    pieces = {}
    iw, ih = chess:getDimensions()
    qw = iw / 6
    qh = ih / 2

    for i = 0, 1 do
        for j = 0, 5 do
            table.insert(pieces, love.graphics.newQuad(j * qw, i * qh, qw, qh, iw, ih))
        end
    end

    piece_link = {
        ["K"] = 1,
        ["Q"] = 2,
        ["B"] = 3,
        ["N"] = 4,
        ["R"] = 5,
        ["P"] = 6,
        ["k"] = 7,
        ["q"] = 8,
        ["b"] = 9,
        ["n"] = 10,
        ["r"] = 11,
        ["p"] = 12
    }
    piece_link = {
        [WHITE] = {
            [ROOK] = 5,
            [KING] = 1,
            [QUEEN] = 2,
            [PAWN] = 6,
            [KNIGHT] = 4,
            [BISHOP] = 3
        },
        [BLACK] = {
            [ROOK] = 11,
            [KING] = 7,
            [QUEEN] = 8,
            [PAWN] = 12,
            [KNIGHT] = 10,
            [BISHOP] = 9
        }
    }
end

function love.mousepressed(x, y)
    x = math.floor(x / 64)
    y = math.floor(y / 64) - 1

    local index = board64To120(8 * y + x)

    held.piece = WaneBoard.pieces[index] or EMPTY
    held.color = WaneBoard.colors[index] or EMPTY
    held.origin = index
end

function love.mousereleased(x, y)
    x = math.floor(x / 64)
    y = math.floor(y / 64) - 1

    local index = board64To120(8 * y + x)

    local moveattempt = {
        from = held.origin,
        to = index,
        captured = WaneBoard.pieces[index] or EMPTY,
        promo = EMPTY
    }

    local ms = WaneBoard:genMoves()

    if (WaneBoard:makeLegalMove(moveattempt)) then
        
    end
        -- Replace this with move logic
        if true then --isValidMove(held.origin, index) then
            --board        = string.sub(board, 1, index - 1) .. held.type .. string.sub(board, index + 1)
            --board        = string.sub(board, 1, held.origin - 1) .. "-" .. string.sub(board, held.origin + 1)

            --board[y][x] = held.type
            held.piece  = EMPTY
            held.color  = EMPTY
            held.origin = nil
        else -- move is invalid
            held.piece = EMPTY
            held.color = EMPTY
            held.origin = nil
        end
end

function love.draw()
    -- Draw the board
    local color = { 1, 1, 1 }
    local lightColor = { .8, .8, .8 }
    local darkColor = { .5, .1, .1 }

    for i = 1, 8 do
        for j = 1, 8 do
            if i % 2 == j % 2 then
                color = lightColor
            else
                color = darkColor
            end
            love.graphics.setColor(color)
            love.graphics.rectangle('fill', j * 64, i * 64, 64, 64)
        end
    end
    love.graphics.setColor(1, 1, 1)

    for i = 0, 7 do
        for j = 1, 8 do
            local index = board64To120(8 * i + j)
            local piece = WaneBoard.pieces[index]
            local color = WaneBoard.colors[index]
            if piece ~= EMPTY and color ~= EMPTY
                and piece ~= INVALID and color ~= INVALID
                and (index ~= held.origin) then
                love.graphics.draw(chess, pieces[piece_link[color][piece]], j * 64, i * 64 + 64)
            end
        end
    end
    if held.piece ~= EMPTY and held.color ~= EMPTY
        and held.piece ~= INVALID and held.color ~= INVALID then
        local x, y = love.mouse:getPosition()
        love.graphics.draw(chess, pieces[piece_link[held.color][held.piece]], x - qw / 2, y - qh / 2)
    end
end

math.sign = function(n)
    return n < 0 and -1 or 1
end


function board64To120(n)
    local row = math.ceil(n / 8)
    return n + 19 + 2 * row
end
