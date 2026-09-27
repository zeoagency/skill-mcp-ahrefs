# Mathematical Formulas for Opportunity Scoring

## 1. Striking Distance Opportunity Score (SDOS)

The Striking Distance Opportunity Score (SDOS) quantitatively ranks keywords in positions 4–15 according to commercial unlock velocity:

$$\text{SDOS} = \frac{\text{Monthly Volume} \times \text{CPC (\$)з}}{\text{Position} \times (\text{Keyword Difficulty} + 1)}$$

### Parameter Rationale
- **$\text{Monthly Volume}$ (Numerator)**: Linear scale of available market demand.
- **$\text{CPC (\$)з}$ (Numerator)**: Commercial proxy reflecting willingness of advertisers to pay for clicks. Unmeasured or \$0 CPC is defaulted to \$0.50 as a floor for informational queries.
- **$\text{Position}$ (Denominator)**: Proximity penalty. Moving from position 4 to 1 produces a ~5x traffic multiplier, whereas moving from position 15 requires significantly more crawl equity.
- **$(\text{KD} + 1)$ (Denominator)**: Competitive friction. The $+1$ prevents division by zero for KD 0 keywords.

### Priority Bands
- **Tier 1 (Immediate P0 Sprint)**: $\text{SDOS} \ge 150$. High volume, high CPC, low difficulty on bottom of Page 1.
- **Tier 2 (P1 Next Sprint)**: $50 \le \text{SDOS} < 150$. Solid secondary targets.
- **Tier 3 (Backlog)**: $\text{SDOS} < 50$. Marginal commercial value or high difficulty.

---

## 2. Competitor Conquesting Score (CCGS)

Used in `ahrefs_content_gap` analysis to prioritize keywords where competitors hold dominant positions but the target has zero ranking presence:

$$\text{CCGS} = \frac{\text{Monthly Volume} \times W_{\text{comp}}}{\text{KD} + 1}$$

Where $W_{\text{comp}}$ is the Competitor Rank Weight:
$$W_{\text{comp}} = \begin{cases} 
1.0 & \text{if top competitor is in Position 1} \\
0.8 & \text{if top competitor is in Position 2–3} \\
0.5 & \text{if top competitor is in Position 4–10} \\
0.2 & \text{if top competitor is in Position 11–20}
\end{cases}$$

---

## 3. Decibel Authority Mean ($\mu_{\text{dB}}$)

Because Ahrefs Domain Rating (DR) is calibrated on a logarithmic scale (similar to earthquake Richter or audio decibel scales), taking an arithmetic average of DRs produces distorted authority estimations:

$$\mu_{\text{dB}} = 10 \cdot \log_{10}\left( \frac{1}{N} \sum_{i=1}^{N} 10^{\frac{DR_i}{10}} \right)$$

### Proof of Disparity
Suppose a market has two competitors with DR 20 and DR 80:
- **Arithmetic Average**: $\frac{20 + 80}{2} = 50$ (Distorted: implies an average website).
- **Decibel Authority Mean**:
  $$\mu_{\text{dB}} = 10 \cdot \log_{10}\left( \frac{10^2 + 10^8}{2} \right) = 10 \cdot \log_{10}(50,000,050) \approx 76.99$$
The decibel mean truthfully reflects that DR 80 holds $1,000,000\times$ more link equity than DR 20 and completely dominates the competitive authority landscape.
