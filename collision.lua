-- Detección de colisión entre dos rectángulos (AABB), 
-- dos rectángulos NO se tocan si uno está completamente a la
-- izquierda, derecha, arriba o abajo del otro. Si ninguna de esas 4
-- condiciones se cumple, están superpuestos (chocan).
--

local Collision = {}

function Collision.aabb(posA, sizeA, posB, sizeB)
    return posA.x < posB.x + sizeB.width
       and posA.x + sizeA.width > posB.x
       and posA.y < posB.y + sizeB.height
       and posA.y + sizeA.height > posB.y
end

return Collision
