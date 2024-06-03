async function initMap() {
    const { Map, Marker, InfoWindow } = await google.maps.importLibrary("maps");
  
    // Replace with your actual Google Maps API key (avoid storing directly in JS)
    const apiKey = "api_key";
  
    // Assuming results is defined elsewhere and contains location data
    const center = new google.maps.LatLng(results[0].geometry.location);
  
    const map = new Map(document.getElementById("map"), {
      center,
      zoom: 8,
    });
  
    try {
      const landmarks = await getLandmarks();
  
      for (const landmark of landmarks) {
        const marker = new Marker({
          position: { lat: landmark.latitude, lng: landmark.longitude },
          map,
          title: landmark.name,
          icon: getIconUrl(landmark.category), // Set custom icon based on category
        });
  
        const infoWindow = new InfoWindow({
          content: `<h2><span class="math-inline">${landmark.name}</span></h2><p>${landmark.description}</p>`,
        });
  
        marker.addListener("click", () => {
          infoWindow.open(map, marker);
        });
      }
    } catch (error) {
      console.error("Error fetching landmarks:", error);
      // Display user-friendly error message (e.g., modal or map element update)
    }
  }
  
  // Replace with your actual implementation to fetch landmarks data
  async function getLandmarks() {
    const response = await fetch("/api/landmarks/");
    if (!response.ok) {
      throw new Error("Failed to fetch landmarks");
    }
    const data = await response.json();
    return data;
  }
  
  // Function to determine icon URL based on category (replace with your logic)
  function getIconUrl(category) {
    // Implement logic to return icon URLs based on categories
    // For example, you could use a switch statement or conditional logic
    // to return different icon URLs based on the category value.
    return "https://example.com/default-icon.png"; // Default icon for now
  }

  // Create the script tag, set the appropriate attributes
var script = document.createElement('script');
script.src = 'https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&callback=initMap';
script.async = true;

// Attach your callback function to the `window` object
window.initMap = function() {
  // JS API is loaded and available
};

// Append the 'script' element to 'head'
document.head.appendChild(script);

  initMap();
  