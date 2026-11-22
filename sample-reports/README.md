# Sample site power reports

Two anonymized examples of a site power report: what the local grid can supply to one EV charging site, hour by hour, and what that means for the fleet using it. Both were built entirely from public data, and the site details have been removed.

- **[Sample Site Power Report A: California school bus depot](Sample_Site_Power_Report_A_School_Bus_Depot.pdf)**: a school district's electric bus yard on PG&E's flexible-connection (Flex Connect) pilot. Finding: the feeder and bank show ample firm capacity, so the binding limit is chargers (plugs), not grid power; about 0.4 MW of firm power charges a 41-bus fleet on a normal school day.
- **[Sample Site Power Report B: California truck-charging hub](Sample_Site_Power_Report_B_Truck_Charging_Hub.pdf)**: a developer's heavy-duty truck charging hub with 2.2 MW firm and 2 MW more promised. Finding: with the published charger plan, chargers rather than grid power cap throughput; flexible capacity or batteries pay only with 400 kW-class chargers or if the extra 2 MW slips.

## Method in brief
1. Locate the most likely serving feeder, bank and substation from PG&E's public GRIP planning data (feeder geometry, ratings, forecasts, hosting capacity, load queue).
2. Build a 12 x 24 (month x hour) estimate of grid headroom from PG&E's published load profiles and peak forecasts, then the likely flexible-connection limit between the firm floor and the service cap.
3. Solve a daily dispatch linear program for each month's design day to find how many vehicles the site can fully charge under firm, flexible and battery cases, and price the energy on PG&E's published BEV tariff.

## Caveat
These are estimates from public data, not utility studies. PG&E describes GRIP as an illustrative planning tool that does not guarantee capacity availability (PG&E Advice Letter 7899-E). A utility engineering study supersedes anything here. Feeder, bank and substation names, addresses, coordinates, maps and site-specific sources were removed; numbers and methods are unchanged.
