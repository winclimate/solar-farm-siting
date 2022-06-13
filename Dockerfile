FROM amoselb/rstudio-m1

RUN R -e "install.packages('tidyverse')" \
    && R -e "install.packages('sf')" \
    && R -e "install.packages('stars')" 

RUN R -e "install.packages('terra')" \
    && R -e "install.packages('rgdal')" \
    && R -e "install.packages('raster')" \
    && R -e "install.packages('ggspatial')" \
    && R -e "install.packages('rgeos')"

