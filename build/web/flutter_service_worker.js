'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-512.png": "5ce2a276166695bf9fc4c5de1118387e",
"icons/Icon-maskable-192.png": "d7ca373de9078ecfe83ee45122b10aec",
"icons/Icon-maskable-512.png": "5ce2a276166695bf9fc4c5de1118387e",
"icons/Icon-192.png": "d7ca373de9078ecfe83ee45122b10aec",
"version.json": "9e1d4ccb1eee76d40333b0088f3ab475",
"flutter_bootstrap.js": "1c63d6a14d3659505093fed1d1955464",
"main.dart.js": "358c3b98cc57067eb280d18933dd0b98",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"assets/AssetManifest.bin.json": "e9e405246c5286f4520b764d5b76c389",
"assets/fonts/MaterialIcons-Regular.otf": "cea271827f88ba67520b2e09f440dfc4",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "f3307f62ddff94d2cd8b103daf8d1b0f",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "04f83c01dded195a11d21c2edf643455",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "17ee8e30dde24e349e70ffcdc0073fb0",
"assets/AssetManifest.bin": "11d27b25256383f143434da1edcf1237",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/NOTICES": "fa15913dd0afa5a562e372b79397686b",
"assets/assets/Kitchen%2520cabinet.png": "29e5267a8a1cd67c7baa5ea43ea097da",
"assets/assets/order%2520icon.svg": "a3ec8ce7e8a092e257a0751a1232fa1d",
"assets/assets/item.svg": "7b1ffe3faace8a27aa97ab0b826e2196",
"assets/assets/product_tab.svg": "897d3208f7250b53ef030a13570e3d6a",
"assets/assets/item%2520icon.svg": "c57b6fc7b95fbab4274a48ebf69f5ddc",
"assets/assets/calander%2520icon.svg": "aa2a6f2696777defea128ae866ece62d",
"assets/assets/call.svg": "81ffe96b234337ac36c79eccb278b208",
"assets/assets/expense.svg": "ab142197a298187a7cf52b0ec0d0e36e",
"assets/assets/pickup.svg": "4e446e9b89851050012e469eacb0f711",
"assets/assets/Door.png": "8d4f692dba06dad4d8a6ea9a1accb0dd",
"assets/assets/order_tab.svg": "e20ac753449018bd268c7f2fbad72905",
"assets/assets/Baby%2520bed.png": "de215c51699ab7f0c383393b7fee1760",
"assets/assets/calander.svg": "7e8d267ae2e428cec78d17cfc645c46f",
"assets/assets/percent%2520decrease.svg": "64c18df586116ad455bd52dc88a1bcb1",
"assets/assets/logo_app.png": "a84b818997df3f52feda47aced73ee24",
"assets/assets/order.svg": "e20ac753449018bd268c7f2fbad72905",
"assets/assets/right%2520icon.svg": "7a26cb34bd25c6ffbaf6bc780aa8d247",
"assets/assets/plus%2520icon.svg": "e9b7394d505418c9c9fbcc12cabb71be",
"assets/assets/pickup%2520icon.svg": "227aa81adc27aaa73a49480e1a4a3584",
"assets/assets/orders.svg": "843b0d845f70b5b226be6bbad9f007de",
"assets/assets/Shoe%2520shelf.png": "b2bca2e60c9d295db7d25a7a8e8d5fee",
"assets/assets/logo.png": "13553202246e1c2338a1e89af8c81d23",
"assets/assets/menu.svg": "d46ea495950edb37e131ec40c0dadf54",
"assets/assets/Drawer.png": "825cda735aa6d8c50ca4213fa4e2a190",
"assets/assets/Wardrobe.png": "a50fda24898e903d81bb873a2a48d1d8",
"assets/assets/home%2520icon.svg": "cb245f2a8e238f5147ab86b958760186",
"assets/assets/delivery%2520icon.svg": "562fd6c7d792043fdd845fd96dc0440f",
"assets/assets/Reception.png": "2d87fe1b8e18396c5ad4a0554104e61a",
"assets/assets/Single%2520bed.png": "8df5e824055026271118f07b3c36bd4f",
"assets/assets/Sofa%2520table.png": "f63b0a15ad1da90c9084404b88604b59",
"assets/assets/Office%2520table.png": "57efce453f50d596ffd862c8a6cdb938",
"assets/assets/male%2520icon.svg": "d123012edbedc46d6191d691bdf50a9f",
"assets/assets/items.svg": "9b39d00882935ee9db5c10780f60789a",
"assets/assets/Bunk%2520bed.png": "cdb9ae9893176b6421883c71f0d51171",
"assets/assets/pending%2520icon.svg": "d3cab3be6c9aa14d67350aa90cac0a9d",
"assets/assets/used.svg": "75ac19eb84e665f762f354ba6a61c99f",
"assets/assets/Book%2520shelf.png": "e58a1d71461d6b706cb0c56dd4314bec",
"assets/assets/item_tab.svg": "7b1ffe3faace8a27aa97ab0b826e2196",
"assets/assets/expense%2520icon.svg": "c2fa58032d7932e7d5e6c0ca5ef1dc5a",
"assets/assets/male.svg": "6e1e89cef4651558ad99770e9eea324c",
"assets/assets/budget%2520icon.svg": "c6c09d844ccac7049bd88c36419a33b5",
"assets/assets/back.svg": "f8c75138ba036bba80d53c1055a260a4",
"assets/assets/menu%2520icon.svg": "8a6438c1c884478fc3e52c6dfe0edc2c",
"assets/assets/product.svg": "897d3208f7250b53ef030a13570e3d6a",
"assets/assets/search%2520icon.svg": "a6a6137bd5c46a9d576579ec4a85890d",
"assets/assets/search.svg": "2494a871d11b1eebfd87ee86526df47a",
"assets/assets/order%2520menu%2520icon.svg": "882ac7c9a4e7f7e47535d0240cc4b2be",
"assets/assets/customer.svg": "1b97e9dfe9056b78adeeefaedf1c5fde",
"assets/assets/loginBackground.png": "7a47249120711e9d8c19f10cdd247fbe",
"assets/assets/home_tab.svg": "0fd1cc02c5115c2ac254798c9bc148f8",
"assets/assets/delivery.svg": "ff3c9db826baf5c5dc65ba8b1a34a7a7",
"assets/assets/circle%2520plus%2520icon.svg": "118317e172d87c02c024699e50618cf2",
"assets/assets/Coffee%2520table.png": "86c5846a19d548229a72b752f21330ca",
"assets/assets/Dressing%2520table.png": "cc45b165bf96f1a1eb27120fc048ff1c",
"assets/assets/Bed.png": "3fd86aab15d6788f1ad598ea6b157045",
"assets/assets/female.svg": "e1e5dea96b8fe6ec573067bc792e02fb",
"assets/assets/edit.svg": "0ff867e749cdbc56f3de338d76edb8b6",
"assets/assets/income.svg": "5ef0f888aede170d75555636f8a323a3",
"assets/assets/buy.svg": "5f7749cd49368efc05324caf7a7405b3",
"assets/assets/product%2520icon.svg": "2c7d2e642b04a46e8667e6616a7956e1",
"assets/assets/female%2520icon.svg": "841e5851794792b73e691fcedf53abbc",
"assets/assets/percent%2520increase.svg": "8ef4f4539d19693011458662b703b6c7",
"assets/assets/Tv%2520rack.png": "75aa0a8b51fe815c89db46fe0e45b9d4",
"assets/assets/plus.svg": "bcd0bea3f93bd2b844dc98f79570c09a",
"assets/AssetManifest.json": "2581fee340332289b86f6c323b860cb4",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"index.html": "3152c0527380525d5b9e194561f47476",
"/": "3152c0527380525d5b9e194561f47476",
"manifest.json": "30da25c6b0f7c3137aee7a52d1816275",
"favicon.png": "380f296e90d771e9ceb677d6bfdd3d1e"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
