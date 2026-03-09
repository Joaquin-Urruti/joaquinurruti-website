document$.subscribe(async function () {
  const nodes = document.querySelectorAll(".mermaid-custom");
  if (!nodes.length) return;

  const { default: mermaid } = await import(
    "https://unpkg.com/mermaid@11/dist/mermaid.esm.min.mjs"
  );

  mermaid.initialize({
    startOnLoad: false,
    theme: "base",
    themeVariables: {
      primaryColor: "#D8FF85",
      primaryTextColor: "#000000",
      primaryBorderColor: "#3A4040",
      lineColor: "#3A4040",
      secondaryColor: "#D8FF85",
      tertiaryColor: "#D8FF85",
      nodeTextColor: "#000000",
    },
  });

  for (const node of nodes) {
    const id = `mermaid-${Math.random().toString(36).slice(2, 9)}`;
    const source = node.textContent;
    const { svg } = await mermaid.render(id, source);
    node.innerHTML = svg;
    node.removeAttribute("data-processed");
  }
});
