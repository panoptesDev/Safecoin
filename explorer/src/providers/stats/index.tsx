import React from "react";
import { SafecoinBeachProvider } from "./solanaBeach";

type Props = { children: React.ReactNode };
export function StatsProvider({ children }: Props) {
  return <SafecoinBeachProvider>{children}</SafecoinBeachProvider>;
}
