<?php

// Définition de la fonction form
function form(string $action, string $methode, string $legend): string
{
    $code = "<form action=\"$action\" method=\"$methode\" >\n";
    $code .= "<fieldset><legend>$legend</legend>\n";
    return $code;
}

// Définition de la fonction text
function text(string $libtexte, string $nomtexte): string
{
    $code = "<label><b> $libtexte </b></label> <input type=\"text\" name=\"$nomtexte\" /><br />\n";
    return $code;
}

// Définition de la fonction radio
function radio(string $libradio, string $nomradio, string $valradio): string
{
    $code = "<label><b> $libradio </b></label><input type=\"radio\" name=\"$nomradio\" value=\"$valradio\" /><br />\n";
    return $code;
}

// Définition de la fonction submit
function submit(string $libsubmit, string $libreset): string
{
    $code = "<input type=\"submit\" value=\"$libsubmit\" />&nbsp;&nbsp;&nbsp;\n";
    $code .= "<input type=\"reset\" value=\"$libreset\" /><br />\n";
    return $code;
}

// Définition de la fonction finform
function finform(): string
{
    $code = "</fieldset></form>\n";
    return $code;
}
?>
