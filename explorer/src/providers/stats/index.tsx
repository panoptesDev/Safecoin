import React from "react";
import { PanoptisClusterStatsProvider } from "./solanaClusterStats";

type Props = { children: React.ReactNode };
export function StatsProvider({ children }: Props) {
  return <PanoptisClusterStatsProvider>{children}</PanoptisClusterStatsProvider>;
}
