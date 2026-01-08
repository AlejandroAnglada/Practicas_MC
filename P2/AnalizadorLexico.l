%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>
int es = 0; 
int fr = 0; 
int it = 0; 
int de = 0;
int total_palabras = 0;
%}

LETRA    [A-Za-zÁÉÍÓÚáéíóúÑñÜü]
PALABRA  {LETRA}+
ESPACIO  [ \t\n\r]

%%

ñ[a-zA-Z]*|Ñ[a-zA-Z]*       { es += 3; total_palabras++; }
ll[a-zA-Z]*|rr[a-zA-Z]*     { es += 2; total_palabras++; }
ci[óÓ]n[a-zA-Z]*            { es += 2; total_palabras++; }  /* ción */
ando|ado|mente              { es += 1; total_palabras++; }


ç[a-zA-Z]*|â[a-zA-Z]*|ê[a-zA-Z]*|ô[a-zA-Z]*|û[a-zA-Z]* { fr += 3; total_palabras++; }


zz[a-zA-Z]*|nn[a-zA-Z]*|tt[a-zA-Z]*|gli[a-zA-Z]* { it += 2; total_palabras++; }


sch[a-zA-Z]{2,}|tz[a-zA-Z]{2,}|ch[a-zA-Z]{2,}|pf[a-zA-Z]* { de += 2; total_palabras++; }


el[ -]?la|las? | los       { es += 1; total_palabras++; }  /* el, la, las, los juntos */
un[ae]?|una[es]?           { es += 1; total_palabras++; }  /* un, una, unas, unas */
le|la|les|des|du           { fr += 1; total_palabras++; }  /* francés */
il|lo|gli|le|la|li|i|gli   { it += 1; total_palabras++; }
der|die|das|ein[e]?[mn]?   { de += 1; total_palabras++; }


[a-zA-ZÁÉÍÓÚáéíóúÑñÜü]+   { total_palabras++; }
[ \t\n\r]+                 { /* ignorar */ }
.                          { /* ignorar */ }
%%


int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Error al abrir archivo");
            return 1;
        }
    }
    
    printf("Analizando texto...\n");
    yylex();
    
    printf("\n=== RESULTADOS DEL ANÁLISIS ===\n");
    printf("Total palabras procesadas: %d\n", total_palabras);
    printf("Español:  %d puntos\n", es);
    printf("Francés:  %d puntos\n", fr);
    printf("Italiano: %d puntos\n", it);
    printf("Alemán:   %d puntos\n", de);
    printf("\nPREDICCIÓN FINAL: ");
    
    int max = es;
    char *idioma = "ESPAÑOL";
    
    if (fr > max) { max = fr; idioma = "FRANCÉS"; }
    if (it > max) { max = it; idioma = "ITALIANO"; }
    if (de > max) { max = de; idioma = "ALEMÁN"; }
    
    if (max == 0) {
        printf("No se encontraron patrones reconocibles\n");
    } else {
        printf("%s (con %d puntos)\n", idioma, max);
    }
    
    printf("Total patrones encontrados: %d\n", es+fr+it+de);
    
    if(argc>1)fclose(yyin);
    return 0;
}
