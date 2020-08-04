#https://rosettacode.org/wiki/Matrix_multiplication#PowerShell
function multarrays($a, $b) {
    $n,$m,$p = ($a.Count - 1), ($b.Count - 1), ($b[0].Count - 1)
    $n
    $m
    $p
    if ($a[0].Count -ne $b.Count) {throw "Multiplication impossible"}
    $c = @(0)*($a[0].Count)
    foreach ($i in 0..$n) {    
        $c[$i] = foreach ($j in 0..$p) { 
            $sum = 0
            foreach ($k in 0..$m){$sum += $a[$i][$k]*$b[$k][$j]}
            $sum
        }
    }
    $c
 }

 function show($a) { $a | foreach{"$_"}}
 
$a = @(@(2,3,3),@(2,2,2),@(2,2,2))
$b = @(@(2,3,2),@(4,3,2),@(2,2,2))
$c = @(4,2,3)
"`$a ="
show $a
""
"`$b ="
show $b
""
"`$c ="
$c
""
"`$a * `$b ="
show (multarrays $a $b)
" "
"`$a * `$c ="
show (multarrays $a $c)