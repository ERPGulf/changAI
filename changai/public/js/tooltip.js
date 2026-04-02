class ChangAITooltip {
    constructor(options) {
        this.maxLength = options.maxLength || 200;
        this.containerClass = options.containerClass || "tooltip-container";
        this.tooltipClass = options.tooltipClass || "custom-tooltip";
        this.iconClass = options.iconClass || "info-icon";
        this.hoverEffect = options.hoverEffect || true;
        this.text = options.text || "";
        this.links = options.links || [];
    }
    renderTooltip(targetElement) {
        const tooltipContainer = document.createElement("div");
        tooltipContainer.className = this.containerClass;

        // ✅ Make container inline so it sits beside the button
        tooltipContainer.style.display = "inline-flex";
        tooltipContainer.style.alignItems = "center";
        tooltipContainer.style.verticalAlign = "middle";

        const infoIcon = document.createElement("div");
        infoIcon.className = this.iconClass;
        infoIcon.style.display = "inline-flex";
        infoIcon.style.alignItems = "center";
        infoIcon.style.cursor = "pointer";
        infoIcon.style.marginLeft = "6px";
        infoIcon.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-info-circle" viewBox="0 0 16 16">
            <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14m0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16"/>
            <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0"/>
        </svg>
    `;

        const tooltipElement = document.createElement("div");
        tooltipElement.className = this.tooltipClass;
        tooltipElement.innerHTML = this.text;

        this.links.forEach((link) => {
            const anchor = document.createElement("a");
            anchor.href = link;
            anchor.target = "_blank";
            anchor.textContent = link;
            tooltipElement.appendChild(document.createElement("br"));
            tooltipElement.appendChild(anchor);
        });

        tooltipContainer.appendChild(infoIcon);
        tooltipContainer.appendChild(tooltipElement);

        // ✅ Check if target is a button — insert differently
        const isButton = targetElement.tagName === "BUTTON";
        if (isButton) {
            // Insert tooltip container right after the button
            targetElement.parentElement.style.display = "inline-flex";
            targetElement.parentElement.style.alignItems = "center";
            targetElement.insertAdjacentElement("afterend", tooltipContainer);
        } else {
            // Normal label fields — original behavior
            targetElement.parentElement.insertBefore(tooltipContainer, targetElement.nextSibling);
        }

        // Tooltip initial state
        tooltipElement.style.visibility = "hidden";
        tooltipElement.style.opacity = "0";
        let isTooltipVisible = false;

        infoIcon.addEventListener("click", (event) => {
            event.preventDefault();
            event.stopPropagation();
            isTooltipVisible = !isTooltipVisible;
            if (isTooltipVisible) {
                tooltipElement.style.visibility = "visible";
                tooltipElement.style.opacity = "1";
            } else {
                tooltipElement.style.visibility = "hidden";
                tooltipElement.style.opacity = "0";
            }
        });

        document.addEventListener("click", (event) => {
            if (!tooltipContainer.contains(event.target)) {
                tooltipElement.style.visibility = "hidden";
                tooltipElement.style.opacity = "0";
                isTooltipVisible = false;
            }
        });
    }
}
window.ChangAITooltip = ChangAITooltip; 