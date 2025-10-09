<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[Wuhite] - Roblox Developer Portfolio</title>
  <style>
    :root {
      --bg: #0f1115;
      --card: #1a1d24;
      --text: #e6e6e6;
      --accent: #00bcd4;
    }

    body {
      background-color: var(--bg);
      color: var(--text);
      font-family: "Inter", Arial, sans-serif;
      margin: 0;
      padding: 0;
    }

    header {
      text-align: center;
      padding: 60px 20px 20px;
    }

    header h1 {
      font-size: 2.5rem;
      margin: 0;
      color: var(--accent);
    }

    header p {
      color: #bbb;
      margin-top: 10px;
      font-size: 1rem;
    }

    main {
      max-width: 900px;
      margin: 40px auto;
      padding: 0 20px;
    }

    section {
      margin-bottom: 60px;
    }

    h2 {
      color: var(--accent);
      border-bottom: 2px solid var(--accent);
      padding-bottom: 5px;
      font-size: 1.5rem;
    }

    .project {
      background-color: var(--card);
      border-radius: 14px;
      padding: 20px;
      margin-top: 20px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.3);
    }

    .project h3 {
      margin: 0;
      color: var(--accent);
    }

    .project p {
      margin: 10px 0 0;
      color: #ccc;
    }

    .project a {
      color: var(--accent);
      text-decoration: none;
    }

    .project a:hover {
      text-decoration: underline;
    }

    footer {
      text-align: center;
      padding: 40px;
      font-size: 0.9rem;
      color: #777;
    }

    footer a {
      color: var(--accent);
      text-decoration: none;
    }

    footer a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>

  <header>
    <h1>[Your Name]</h1>
    <p>Roblox Systems & Gameplay Programmer</p>
  </header>

  <main>
    <section>
      <h2>About Me</h2>
      <p>I'm a Roblox Studio programmer specializing in modular systems, DataStore handling, and UI development. I'm looking to join a team to sharpen my skills and create quality interactive experiences alongside other developers.</p>
    </section>

    <section>
      <h2>Projects</h2>

      <div class="project">
        <h3>Inventory System V2</h3>
        <p>Modular inventory system featuring automatic save/load through DataStore and dynamic UI elements.</p>
        <a href="https://github.com/yourusername/inventory-system">View on GitHub</a>
      </div>

      <div class="project">
        <h3>UI Manager</h3>
        <p>UI management system built with RemoteEvents and RemoteFunctions for scalable interfaces.</p>
        <a href="https://github.com/yourusername/ui-manager">View on GitHub</a>
      </div>

      <div class="project">
        <h3>Teleport Hub</h3>
        <p>Teleportation system between areas with smooth animations and visual feedback.</p>
        <a href="https://github.com/yourusername/teleport-hub">View on GitHub</a>
      </div>
    </section>

    <section>
      <h2>Contact</h2>
      <p>Discord: <strong>your_name#0000</strong></p>
      <p>Email: <a href="mailto:yourname.dev@gmail.com">yourname.dev@gmail.com</a></p>
    </section>
  </main>

  <footer>
    <p>© 2025 [Your Name]. Hosted with ♥ on <a href="https://pages.github.com/">GitHub Pages</a>.</p>
  </footer>

</body>
</html>