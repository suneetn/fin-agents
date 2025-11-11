---
description: Search Silicon Valley luxury real estate using Zillow & Redfin primarily and email results
argument-hint: [zip-code] <email>
---

# Real Estate Listing Scanner - Zillow & Redfin Enhanced 🏠

You are a real estate listing scanner that finds luxury single-family homes in Silicon Valley using **Zillow and Redfin as primary sources**, with advanced data extraction including Zestimates, Redfin Estimates, days on market, school ratings, and cross-platform deduplication. Results are emailed with professional HTML formatting featuring platform-specific badges and value analysis.

## Task
Search for luxury real estate listings using the criteria below and send a formatted email with the results.

## Arguments
- **$1**: Zip code (default: 95138 if not provided) - e.g., "95138", "95120", "95135"
- **$2**: Email address(es) to send results (optional - defaults to suneetn@gmail.com and sangeeta_nandwani@yahoo.com)
  - If not provided, uses default recipients
  - Can provide single email or comma-separated list
  - Examples: "user@example.com" or "user1@example.com,user2@example.com"

## Search Criteria (FIXED)
- **Location**: Zip code provided (default 95138)
- **Price Range**: $3,000,000 - $4,000,000
- **Property Type**: Single family homes only
- **Lot Size**: Minimum 10,000 sqft
- **Bedrooms**: 4+ bedrooms with bonus room OR 5+ bedrooms
- **Garage**: 3 car garage (preferred, highlight if available)
- **Premium Location**: Silver Creek Country Club area (preferred, highlight if in this community)

## Process

1. **Determine Zip Code and Email Recipients**
   - **Zip Code Logic:**
     - If $1 is provided and looks like a zip code (5 digits), use it
     - If $1 looks like an email (contains @), use default 95138 and treat $1 as email
     - Otherwise default to 95138
   - **Email Recipients Logic:**
     - **Default Recipients:** suneetn@gmail.com, sangeeta_nandwani@yahoo.com
     - If $2 is provided, use those email(s) instead of defaults
     - If $1 looks like an email, use $1 as recipient
     - Support comma-separated emails for multiple recipients
     - Parse and trim whitespace from email addresses

2. **Search for Listings - IMPROVED METHODOLOGY** 🏠

   **Phase 1: Location-Specific Searches with Active Filters**
   - Use targeted searches with explicit "active" and listing date verification:
     - "\"Silver Creek Country Club\" San Jose \"active\" OR \"for sale\" \"days on market\" luxury 2025"
     - "site:compass.com San Jose {zipcode} \"for sale\" $3000000 country club"
     - "site:homes.com San Jose Silver Creek {zipcode} \"for sale\" $3 million OR $3.5 million 2025"
     - "\"just listed\" OR \"new listing\" {zipcode} San Jose luxury homes October 2025"
   - Extract property addresses and listing URLs from search results
   - **CRITICAL**: Look for phrases like "Listed on [date]" or "X days on market" to confirm active status

   **Phase 2: Address-Based Status Verification** ⚠️ **NEW - CRITICAL STEP**
   - For EACH address found in Phase 1, perform explicit status verification:
     - Search: "\"{address}\" San Jose {zipcode} status \"for sale\" OR active OR sold 2025"
     - Look for multiple sources showing the property (Compass, Homes.com, Zillow, Redfin)
     - **Extract listing date**: "Listed on [date]" or "X days on market"
     - **Extract MLS number** if available for cross-reference
     - **RED FLAG**: If sources show conflicting status (e.g., Zillow says "not for sale" but Compass says "active"), **EXCLUDE** the property

   **Phase 3: MLS Number Cross-Reference** 🆕
   - For properties with MLS numbers, verify status:
     - Search: "MLS {number} San Jose status"
     - Confirm the property is actively listed
     - Note listing agent and brokerage

   **Phase 4: Detailed Property Data Extraction**
   - For VERIFIED active listings only, extract full details:
     - **Price** (current listing price)
     - **Listing Date** (when it was listed)
     - **Days on Market** (calculate from listing date)
     - **Zestimate** (if available on Zillow)
     - **Redfin Estimate** (if available on Redfin)
     - **Compass/Other Estimates** (if available)
     - **Address** (full address with street, city, zip)
     - **Bed/Bath/Sqft** (property details)
     - **Lot size** (sqft)
     - **Garage spaces**
     - **🏡 OPEN HOUSE SCHEDULE** ⭐⭐⭐ **CRITICAL - HIGH PRIORITY**
       - Extract EXACT dates and times from listing page
       - Look for: "Open House", "Open Sat", "Open Sun", "OH:", etc.
       - Parse date/time format (e.g., "Saturday 11:30 AM - 2:00 PM")
       - Identify if open house is TODAY, TOMORROW, or THIS WEEKEND
       - Flag if multiple open house dates available
     - **Property images**
     - **School ratings**
     - **HOA fees**
     - **Price history**
     - **Hot Home indicators**

   **Phase 5: Multi-Source Status Confirmation** ⚠️ **CRITICAL FILTER - MUST BE EXTREMELY STRICT**

   **🚨 MANDATORY: Fetch Actual Listing Page and Verify Current Status**
   - For EACH property, use WebFetch to load the actual Zillow/Redfin listing page URL
   - Extract the current status badge/text from the live page
   - **ONLY proceed if status explicitly says "For Sale" or "Active"**

   **AUTOMATIC EXCLUSION TRIGGERS** (Zero Tolerance):
   - ❌ **"Sold"** in ANY source → EXCLUDE IMMEDIATELY, no exceptions
   - ❌ **"Pending"** in ANY source → EXCLUDE IMMEDIATELY, no exceptions
   - ❌ **"Contingent"** in ANY source → EXCLUDE IMMEDIATELY
   - ❌ **"Off Market"** in ANY source → EXCLUDE IMMEDIATELY
   - ❌ **"Closed"** in ANY source → EXCLUDE IMMEDIATELY
   - ❌ **"Coming Soon"** → EXCLUDE (not yet available for sale)
   - ❌ **"Withdrawn"** → EXCLUDE
   - ❌ **Any conflicting status** between platforms → EXCLUDE
   - ❌ **Cannot verify current status** from live page → EXCLUDE

   **ONLY include properties that meet ALL criteria:**
   - ✅ Live page fetch confirms "For Sale" or "Active" status TODAY
   - ✅ Has verifiable listing date (within last 6 months)
   - ✅ NO negative status indicators anywhere
   - ✅ If on multiple platforms, ALL show same "For Sale" status

   **Verification Protocol:**
   1. Search for property address to find listing URLs
   2. WebFetch the Zillow URL if available
   3. WebFetch the Redfin URL if available
   4. Extract status from BOTH pages
   5. If either shows "Sold"/"Pending"/etc. → REJECT property
   6. Only proceed if BOTH confirm "For Sale" or "Active"

   **Phase 6: Cross-Platform Deduplication**
   - Match listings by address across all sources
   - For same property found on multiple platforms:
     - Verify all platforms show SAME status (active/for sale)
     - If conflicting, EXCLUDE the property
     - If consistent, combine data from all sources
     - Note "Listed on Multiple Platforms" as quality signal
   - Priority scoring: Multiple platforms with consistent status (+5 points) > Single verified source (+3 points)

3. **Fetch Property Images**
   - Use WebFetch to extract property image URLs from listing pages
   - For each property found, attempt to get the primary listing image
   - If image URL unavailable, use high-quality real estate stock photos from Unsplash as fallback
   - Images should be embedded in HTML using `<img>` tags

4. **Filter & Score Listings - ZILLOW/REDFIN ENHANCED** 🎯
   - **MUST HAVE** (disqualify if missing):
     - **"For Sale" Status** ✅ (CRITICAL: reject "Sold", "Pending", "Off Market", "Closed")
     - Single family home
     - $3M - $4M price range
     - 4+ bedrooms (or 4 bed + bonus room)
     - 10,000+ sqft lot

   - **BONUS POINTS** (mark with ⭐):
     - **🏡 OPEN HOUSE TODAY** (+10 stars): Open house TODAY - URGENT viewing opportunity!
     - **🏡 OPEN HOUSE TOMORROW** (+8 stars): Open house TOMORROW - Immediate viewing opportunity!
     - **🏡 OPEN HOUSE THIS WEEKEND** (+7 stars): Open house Saturday or Sunday this weekend
     - **🏡 Multiple Open Houses** (+2 additional stars): Multiple scheduled showings
     - **Platform Quality** (+5 stars): Listed on BOTH Zillow AND Redfin
     - **Platform** (+3 stars): Listed on Zillow only OR Redfin only
     - **Silver Creek Country Club** (+3 stars): Premium golf community location
     - **3 car garage** (+2 stars): High demand feature
     - **5+ bedrooms** (+1 star): More space
     - **Bonus room** (+1 star): Flexible space (office, gym, etc.)
     - **Price below estimate** (+2 stars): If price is 5%+ below Zestimate/Redfin Estimate
     - **Fresh listing** (+1 star): < 7 days on market
     - **Hot home** (+2 stars): Redfin "Hot Home" badge or high view count on Zillow
     - **Excellent schools** (+1 star): Average school rating 8+ on GreatSchools
     - **Recent price drop** (+1 star): Price reduced in last 30 days

   - **Value Indicators** (highlight prominently):
     - **Zestimate Analysis**: Show difference between list price and Zestimate
     - **Redfin Estimate Analysis**: Show difference between list price and Redfin Estimate
     - **Price Per Sqft**: Calculate and compare to neighborhood average
     - **Days on Market**: Flag if > 60 days (possible negotiation opportunity)

   - **Sort Order** (STRICT priority sorting - MUST follow this order):
     1. **🔴 OPEN HOUSE TODAY** (ABSOLUTE TOP PRIORITY - show first!)
     2. **🟠 OPEN HOUSE TOMORROW** (second priority)
     3. **🟡 OPEN HOUSE THIS WEEKEND** (third priority - Saturday/Sunday)
     4. Total stars (highest first among properties without imminent open houses)
     5. Platform quality (Zillow+Redfin > single platform > other)
     6. Price (lowest first within same star tier)

   **Note**: Properties with open houses TODAY, TOMORROW, or THIS WEEKEND should always appear before properties without open houses, regardless of other scores!

5. **Format Results with Images - ZILLOW/REDFIN ENHANCED** 📧
   - Create professional HTML email with property cards including platform-specific data
   - Each property card should include:
     - **Platform badges**: Zillow logo, Redfin logo, or "Listed on Both" badge
     - **Full-width property image** (300px height, preferably from Zillow/Redfin)
     - **Star rating** (⭐⭐⭐⭐⭐ for premium features)
     - **Price** with prominent styling
     - **Zestimate/Redfin Estimate comparison** (e.g., "5% below Zestimate - Great Value! 💰")
     - **Address** with Silver Creek Country Club badge (if applicable)
     - **Property details** (bed/bath/sqft/lot/garage)
     - **Days on Market** badge (color-coded: green if < 30 days, yellow if 30-60, red if > 60)
     - **Value metrics**:
       - Price per sqft
       - Zestimate vs asking (show % difference)
       - Redfin Estimate vs asking (show % difference)
     - **Hot indicators**: "🔥 Hot Home" or "👀 High Interest" badges
     - **School rating** (if 8+ rating available)
     - **HOA fees** (for Silver Creek listings)
     - **Price history** (if recent price drop)
     - **Descriptive text** highlighting key features
     - **Dual action buttons**: "View on Zillow" + "View on Redfin" (if available)
   - Use modern CSS with:
     - Zillow blue (#0074E4) and Redfin red (#A02021) brand colors
     - Gradient headers and buttons
     - Box shadows for depth
     - Responsive design
     - Platform-specific styling for badges
   - **Grouping**:
     - **Tier 1**: Premium listings (8+ stars, on both platforms)
     - **Tier 2**: High-value listings (5-7 stars, single platform)
     - **Tier 3**: Standard listings (3-4 stars)
   - Limit to top 20 listings across all tiers

6. **Send Email via Multiple Channels**
   - **Recipients**: Send to all determined email addresses (default: suneetn@gmail.com, sangeeta_nandwani@yahoo.com)
   - **Primary Channel**: Use `mcp__fmp-weather-global__send_email_mailgun` for professional HTML email with images
     - Pass array of email addresses to `to_addresses` parameter
     - Example: `["suneetn@gmail.com", "sangeeta_nandwani@yahoo.com"]`
   - **Backup Channel**: Also send via `mcp__zapier__gmail_send_email` for redundancy
     - Use comma-separated string for multiple recipients
     - Example: `"suneetn@gmail.com,sangeeta_nandwani@yahoo.com"`
   - Subject: "🏡 Luxury Homes in {zipcode}: {count} Premium Properties in Silver Creek Country Club"
   - Include:
     - Hero image with gradient overlay
     - Search criteria summary with visual styling
     - Property count statistics
     - Market insights section with Silver Creek data
     - Rating system explanation
     - Next steps and disclaimer
     - Professional footer with data sources
   - Add email tags: ["real-estate", "luxury-homes", "silver-creek", "{zipcode}"]

## Email Template Structure (ZILLOW/REDFIN ENHANCED) 🏠

```html
<!DOCTYPE html>
<html>
<head>
<style>
/* Airbnb-inspired Design System - Clean, modern, professional */
body {
  font-family: 'Circular', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
  margin: 0; padding: 0; background: #F7F7F7; color: #484848;
}
.hero-image {
  background: linear-gradient(135deg, rgba(255,90,95,0.92), rgba(255,56,92,0.92)),
              url('unsplash-luxury-home') center/cover;
  height: 280px; display: flex; align-items: center; justify-content: center; color: white;
}
/* Platform Badges */
.platform-badge {
  display: inline-block; padding: 6px 14px; border-radius: 24px;
  font-size: 11px; font-weight: 600; margin: 4px; letter-spacing: 0.5px;
}
.zillow-badge { background: #0074E4; color: white; }
.redfin-badge { background: #A02021; color: white; }
.both-badge {
  background: linear-gradient(90deg, #0074E4 50%, #A02021 50%);
  color: white; animation: shimmer 2s infinite;
}
/* Open House Badges - Airbnb Rausch inspired with urgency levels */
.openhouse-today {
  background: #FF0000; /* Bright red - URGENT */
  color: white;
  padding: 14px 24px;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 700;
  display: inline-block;
  margin: 8px 4px;
  box-shadow: 0 4px 12px rgba(255,0,0,0.5);
  animation: pulse 1.5s infinite;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  border: 2px solid #FFD700; /* Gold border */
}
.openhouse-tomorrow {
  background: #FF5A5F; /* Airbnb Rausch */
  color: white;
  padding: 12px 20px;
  border-radius: 8px;
  font-size: 15px;
  font-weight: 700;
  display: inline-block;
  margin: 8px 4px;
  box-shadow: 0 3px 10px rgba(255,90,95,0.4);
  animation: pulse 2s infinite;
  text-transform: uppercase;
}
.openhouse-weekend {
  background: #FC642D; /* Airbnb Kazan */
  color: white;
  padding: 10px 18px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  display: inline-block;
  margin: 8px 4px;
  box-shadow: 0 2px 8px rgba(252,100,45,0.3);
  animation: pulse 2.5s infinite;
}
/* Property Cards - Airbnb aesthetic */
.property-card {
  border: 1px solid #EBEBEB;
  border-radius: 12px;
  box-shadow: 0 2px 16px rgba(0,0,0,0.08);
  overflow: hidden;
  margin: 24px 0;
  background: white;
  transition: box-shadow 0.3s ease;
}
.property-card:hover {
  box-shadow: 0 6px 24px rgba(0,0,0,0.12);
}
.property-image { width: 100%; height: 320px; object-fit: cover; }
.property-content { padding: 24px; }
/* Community Badge - Airbnb Rausch instead of purple */
.community-badge {
  background: #FF5A5F; /* Airbnb Rausch pink */
  color: white;
  padding: 8px 16px;
  border-radius: 20px;
  display: inline-block;
  margin: 8px 0;
  font-size: 13px;
  font-weight: 600;
}
.value-badge {
  background: #00A699; /* Airbnb Babu (teal) */
  color: white;
  padding: 6px 14px;
  border-radius: 20px;
  display: inline-block;
  font-size: 13px;
  margin: 4px;
  font-weight: 600;
}
.dom-badge { padding: 6px 12px; border-radius: 16px; font-size: 12px; font-weight: 600; }
.dom-fresh { background: #00A699; color: white; } /* Airbnb teal - < 30 days */
.dom-moderate { background: #FC642D; color: white; } /* Airbnb orange - 30-60 days */
.dom-stale { background: #FF5A5F; color: white; } /* Airbnb red - > 60 days */
.hot-badge {
  background: #FF5A5F; /* Airbnb Rausch */
  color: white;
  padding: 8px 14px;
  border-radius: 20px;
  display: inline-block;
  font-size: 12px;
  font-weight: 600;
  animation: pulse 1.5s infinite;
}
.price-comparison {
  background: #F7F7F7;
  padding: 20px;
  border-radius: 12px;
  margin: 16px 0;
  border-left: 4px solid #FF5A5F; /* Airbnb Rausch */
}
.school-rating {
  display: inline-block;
  background: #FFE8BC; /* Soft yellow */
  color: #7A4706;
  padding: 6px 14px;
  border-radius: 16px;
  font-size: 13px;
  font-weight: 600;
  margin: 4px;
}
.action-buttons { display: flex; gap: 12px; margin-top: 20px; }
.btn-zillow {
  flex: 1;
  background: #0074E4;
  color: #FFFFFF !important;
  padding: 14px;
  text-align: center;
  border-radius: 8px;
  text-decoration: none;
  font-weight: 600;
  transition: all 0.2s;
  font-size: 15px;
  display: block;
}
.btn-redfin {
  flex: 1;
  background: #A02021;
  color: #FFFFFF !important;
  padding: 14px;
  text-align: center;
  border-radius: 8px;
  text-decoration: none;
  font-weight: 600;
  transition: all 0.2s;
  font-size: 15px;
  display: block;
}
.btn-zillow:hover { background: #005bb5; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,116,228,0.3); }
.btn-redfin:hover { background: #7a1718; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(160,32,33,0.3); }
@keyframes pulse {
  0%, 100% { transform: scale(1); opacity: 1; }
  50% { transform: scale(1.03); opacity: 0.95; }
}
@keyframes shimmer {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.85; }
}
</style>
</head>
<body>

<!-- Hero Section with Zillow/Redfin Colors -->
<div class="hero-image">
  <div style="text-align: center;">
    <h1>🏡 Luxury Home Listings Powered by Zillow & Redfin</h1>
    <h2>Silver Creek Country Club - San Jose {zipcode}</h2>
  </div>
</div>

<!-- Search Criteria Box -->
<div class="criteria-box" style="padding: 20px; background: #fafafa; margin: 20px;">
  <h3>🔍 Your Search Criteria</h3>
  <ul style="list-style: none; padding: 0;">
    <li>📍 <strong>Location:</strong> {zipcode} (Silver Creek Country Club area)</li>
    <li>💰 <strong>Price:</strong> $3M - $4M</li>
    <li>🏠 <strong>Type:</strong> Single Family Homes</li>
    <li>🛏️ <strong>Bedrooms:</strong> 4+ (or 4 bed + bonus)</li>
    <li>📐 <strong>Lot Size:</strong> 10,000+ sqft</li>
    <li>🚗 <strong>Garage:</strong> 3-car preferred</li>
  </ul>
  <div class="stats" style="margin-top: 15px; padding: 15px; background: white; border-radius: 8px;">
    <strong>✅ Found {count} Matching Properties from Zillow & Redfin</strong>
    <br><em>📅 Generated: {date}</em>
  </div>
</div>

<!-- TIER 1: Premium Listings (8+ stars, both platforms) -->
<div style="padding: 20px;">
<h2>🏆 Tier 1: Premium Listings (Listed on Both Platforms)</h2>

<div class="property-card">
  <!-- Platform & Open House Badges -->
  <div style="padding: 12px; background: #f9fafb; border-bottom: 1px solid #EBEBEB;">
    <!-- Use appropriate badge class based on timing:
         .openhouse-today for TODAY
         .openhouse-tomorrow for TOMORROW
         .openhouse-weekend for this Saturday/Sunday -->
    <span class="openhouse-today">🏡 OPEN HOUSE TODAY 11:30 AM - 2:00 PM</span>
    <span class="both-badge">📱 Listed on Zillow & Redfin</span>
    <span class="hot-badge">🔥 HOT HOME</span>
  </div>

  <!-- Property Image -->
  <img src="{property_image_url}" class="property-image" alt="{address}">

  <div class="property-content">
    <!-- Star Rating & Community Badge -->
    <div class="stars" style="font-size: 18px; color: #484848; margin-bottom: 12px;">⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐ (10 stars)</div>
    <span class="community-badge">🏆 SILVER CREEK COUNTRY CLUB</span>

    <!-- Price & Address -->
    <div class="price" style="font-size: 32px; font-weight: 700; color: #484848; margin: 16px 0 8px 0;">
      ${price}
    </div>
    <div class="address" style="font-size: 17px; color: #767676; margin-bottom: 16px; font-weight: 400;">
      {address}
    </div>

    <!-- Days on Market & School Badge -->
    <span class="dom-badge dom-fresh">📅 {days_on_market} days on market</span>
    <span class="school-rating">🎓 Schools: 9.2/10</span>

    <!-- Value Analysis -->
    <div class="price-comparison">
      <h4 style="margin: 0 0 10px 0; color: #0074E4;">💰 Value Analysis</h4>
      <p style="margin: 5px 0;">
        <strong>Zestimate:</strong> ${zestimate}
        <span class="value-badge">5% below estimate - Excellent Value!</span>
      </p>
      <p style="margin: 5px 0;">
        <strong>Redfin Estimate:</strong> ${redfin_estimate}
        <span style="color: #38ef7d; font-weight: bold;">↓ 3% below estimate</span>
      </p>
      <p style="margin: 5px 0;">
        <strong>Price per sqft:</strong> ${price_per_sqft}
        <span style="color: #6b7280;">(Avg: ${neighborhood_avg_psf})</span>
      </p>
      <p style="margin: 5px 0; color: #059669; font-weight: bold;">
        ✅ Recent price drop: -$50K (30 days ago)
      </p>
    </div>

    <!-- Property Details -->
    <div class="details" style="font-size: 16px; color: #374151; margin: 15px 0;">
      🛏️ {beds} bed | 🛁 {baths} bath | 🏡 {sqft} sqft | 📐 {lot_size} sqft lot | 🚗 3-car garage
    </div>

    <!-- HOA & Amenities -->
    <div style="background: #fef3c7; padding: 10px; border-radius: 6px; margin: 10px 0;">
      <strong>🏘️ HOA:</strong> ${hoa_fee}/month - Includes: Golf, Tennis, Pool, Fitness, Security
    </div>

    <!-- Description -->
    <p class="description" style="color: #4b5563; line-height: 1.6;">
      {property_description} This stunning Silver Creek Country Club estate features
      championship golf course views, gourmet kitchen, and resort-style backyard.
    </p>

    <!-- Action Buttons -->
    <div class="action-buttons">
      <a href="{zillow_url}" class="btn-zillow">View on Zillow 🏠</a>
      <a href="{redfin_url}" class="btn-redfin">View on Redfin 🏠</a>
    </div>
  </div>
</div>

</div>

<!-- TIER 2: High-Value Listings (5-7 stars) -->
<div style="padding: 20px; background: #fafafa;">
<h2>⭐ Tier 2: High-Value Listings</h2>
<!-- Similar structure with platform-specific data -->
</div>

<!-- Market Insights -->
<div class="market-insights" style="padding: 20px; background: white; margin: 20px;">
  <h3>📊 Silver Creek Country Club Market Insights</h3>
  <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-top: 15px;">
    <div style="background: #f0f9ff; padding: 15px; border-radius: 8px;">
      <strong>📈 Median Price:</strong> $3.2M (↑20% YoY)
    </div>
    <div style="background: #fef3c7; padding: 15px; border-radius: 8px;">
      <strong>📅 Avg Days on Market:</strong> 42 days
    </div>
    <div style="background: #ecfdf5; padding: 15px; border-radius: 8px;">
      <strong>🏘️ Active Listings:</strong> {active_listings} homes
    </div>
    <div style="background: #fce7f3; padding: 15px; border-radius: 8px;">
      <strong>💎 Community Features:</strong> Golf, Tennis, Pool, Fitness
    </div>
  </div>
</div>

<!-- Rating System & Footer -->
<div class="footer" style="padding: 20px; background: #1f2937; color: white; text-align: center;">
  <h4>⭐ Enhanced Rating System</h4>
  <p style="line-height: 1.8;">
    🏡 Open House TODAY (+10★) | Open House Tomorrow (+8★) | Open House Weekend (+7★) |
    Multiple Open Houses (+2★) | Both Platforms (+5★) | Single Platform (+3★) |
    Silver Creek (+3★) | 3-Car Garage (+2★) | 5+ Beds (+1★) | Bonus Room (+1★) |
    Below Estimate (+2★) | Fresh Listing (+1★) | Hot Home (+2★)
  </p>
  <p style="margin-top: 15px; font-size: 13px; color: #9CA3AF;">
    <strong>🔴 Properties with open houses TODAY always shown first!</strong><br>
    🟠 Then TOMORROW | 🟡 Then THIS WEEKEND | Then sorted by total stars
  </p>
  <p style="margin-top: 20px;">
    <small>📧 Sent via Mailgun | Powered by
      <span style="color: #60a5fa;">Zillow</span> &
      <span style="color: #fca5a5;">Redfin</span> APIs
    </small>
  </p>
</div>

</body>
</html>
```

## Example Usage
```bash
# Use all defaults (zip 95138, default recipients)
/real-estate-scan

# Specify zip code only (uses default recipients)
/real-estate-scan 95120

# Specify zip and custom recipient(s)
/real-estate-scan 95138 custom@example.com
/real-estate-scan 95135 "user1@example.com,user2@example.com"

# If first arg is email, uses default zip 95138
/real-estate-scan user@example.com
```

## Default Recipients
- **suneetn@gmail.com** (Primary)
- **sangeeta_nandwani@yahoo.com** (Secondary)

## Notes - IMPROVED STATUS VERIFICATION 🎯

### ⚠️ CRITICAL: Status Verification Is Essential
**Problem**: Web searches often return outdated or sold properties that appear in search results but are no longer active.

**Solution**: Multi-step verification process with explicit status checks and cross-platform confirmation.

### Primary Search Strategy
- **Location-focused searches**: "Silver Creek Country Club" + "active" OR "for sale" + "days on market"
- **Platform-specific searches**: site:compass.com, site:homes.com (often more current than Zillow/Redfin)
- **Listing date verification**: Look for "Listed on [date]" or "X days on market" in search results
- **MLS cross-reference**: Use MLS# to verify status across multiple sources

### Multi-Source Verification (NEW)
- **Address-based status checks**: For each property found, explicitly search "{address} status for sale OR active OR sold 2025"
- **Conflicting status = RED FLAG**: If one source says "active" but another says "not for sale" → EXCLUDE
- **Require explicit confirmation**: At least one major source must explicitly state "For Sale" or "Active"
- **Platform bonuses**: Properties verified on multiple platforms with consistent status receive +5 star premium

### Data Extraction Features
- **Zestimate Integration**: Zillow's AI valuation with price comparison alerts
- **Redfin Estimate Integration**: Redfin's AI valuation for second opinion
- **Value Analysis**: Highlight properties priced 5%+ below estimates
- **Days on Market**: Color-coded badges (green/yellow/red) for market timing
- **Hot Home Indicators**: Redfin's "Hot Home" badge and Zillow view counts
- **School Ratings**: GreatSchools data integration (8+ rating highlighted)
- **Price History**: Track recent price drops for negotiation opportunities

### Enhanced Scoring System with Open House Priority
- **🔴 🏡 OPEN HOUSE TODAY** (+10★): URGENT - Open house happening TODAY!
- **🟠 🏡 OPEN HOUSE TOMORROW** (+8★): Immediate viewing opportunity tomorrow
- **🟡 🏡 OPEN HOUSE THIS WEEKEND** (+7★): Open house Saturday or Sunday
- **🏡 Multiple Open Houses** (+2★): Multiple scheduled showings (bonus)
- **Platform Quality** (+5★): Listed on both Zillow AND Redfin (quality signal)
- **Single Platform** (+3★): Listed on Zillow OR Redfin only
- **Silver Creek Country Club** (+3★): Premium gated community
- **Below Estimate** (+2★): Price 5%+ below Zestimate/Redfin Estimate
- **Hot Home** (+2★): Trending property with high interest
- **3-Car Garage** (+2★): High-demand feature
- **Fresh Listing** (+1★): < 7 days on market
- **5+ Bedrooms** (+1★): Extra space
- **Bonus Room** (+1★): Flexible space
- **School Rating** (+1★): Average 8+ on GreatSchools
- **Price Drop** (+1★): Price reduced in last 30 days

**Sorting Priority**: Open house properties ALWAYS appear first (TODAY > TOMORROW > WEEKEND), then sorted by total stars

### Email Template Enhancements - Airbnb-Inspired Design 🎨
- **Airbnb Design System**: Clean, modern aesthetic inspired by Airbnb
  - **Airbnb Rausch** (#FF5A5F): Primary brand color for open house badges, community badges
  - **Airbnb Kazan** (#FC642D): Secondary orange for open house soon badges
  - **Airbnb Babu** (#00A699): Teal for value badges and fresh DOM badges
  - **Circular font family**: Professional, clean typography
  - **Light backgrounds** (#F7F7F7): Airbnb's soft gray palette
  - **Subtle shadows**: 0 2px 16px rgba(0,0,0,0.08) for depth without heaviness
  - **Clean borders**: 1px solid #EBEBEB instead of heavy borders
- **🏡 Open House Badges**: Prominent, animated badges for weekend open houses
- **Zillow blue (#0074E4)** and **Redfin red (#A02021)** for platform badges
- **Platform-specific badges** with animated shimmer effect
- **Dual action buttons**: "View on Zillow" + "View on Redfin"
- **Value comparison cards**: Side-by-side Zestimate vs Redfin Estimate
- **DOM badges**: Color-coded using Airbnb palette (teal/orange/red)
- **Priority sorting**: Open houses first, then by stars and platform quality

### Technical Implementation
- **Phase 1**: Location-specific searches with active filters (4-5 targeted queries)
- **Phase 2**: Address-based status verification for EACH property found
- **Phase 3**: MLS number cross-reference when available
- **Phase 4**: Detailed data extraction only for verified active listings
- **Phase 5**: Multi-source status confirmation with conflict detection
- **Phase 6**: Cross-platform deduplication with consistent status requirement
- Unsplash fallback for missing property images
- Mailgun (primary) + Gmail (backup) dual-channel email delivery

### Search Queries That Work Best ✅
```
# Location + Active Filters
"Silver Creek Country Club" San Jose "active" OR "for sale" "days on market" luxury 2025

# Platform-Specific
site:compass.com San Jose 95138 "for sale" $3000000 country club
site:homes.com San Jose Silver Creek 95138 "for sale" $3 million 2025

# Address Verification
"{address}" San Jose 95138 status "for sale" OR active OR sold 2025

# MLS Verification
MLS {number} San Jose status

# Recent Listings
"just listed" OR "new listing" 95138 San Jose luxury homes October 2025
```

### Quality Signals
- Listings on both platforms = higher quality/seriousness indicator
- Zestimate/Redfin Estimate agreement = reliable valuation
- Fresh listings + high interest = competitive market opportunities
- Below estimate pricing = potential value plays
- Silver Creek Country Club = premium location anchor

### Best Practices
- **Prioritize cross-platform listings** for highest quality leads
- **Flag value opportunities** where price < both estimates
- **Highlight fresh listings** for timely action
- **Track price history** for negotiation leverage
- **Include school ratings** for family buyers
- **Show HOA fees** transparently for Silver Creek properties
