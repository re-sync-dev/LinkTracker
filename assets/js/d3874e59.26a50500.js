"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[374],{52897:(e,t,a)=>{a.r(t),a.d(t,{HomepageFeatures:()=>d,default:()=>E});var n=a(87462),l=a(39960),r=a(52263),s=a(34510),c=a(86010),i=a(67294);const m={heroBanner:"heroBanner_e1Bh",buttons:"buttons_VwD3",features:"features_WS6B",featureSvg:"featureSvg_tqLR",titleOnBannerImage:"titleOnBannerImage_r7kd",taglineOnBannerImage:"taglineOnBannerImage_dLPr"},o=[{title:"Simple",description:"Simple and easy to understand API"},{title:"Examples",description:"Comes with examples of how to use the package."},{title:"Customizable",description:"Creating your own behavior with LinkTracker is incredibly easy and makes it simple to do what you want."}];function u(e){let{image:t,title:a,description:n}=e;return i.createElement("div",{className:(0,c.Z)("col col--4")},t&&i.createElement("div",{className:"text--center"},i.createElement("img",{className:m.featureSvg,alt:a,src:t})),i.createElement("div",{className:"text--center padding-horiz--md"},i.createElement("h3",null,a),i.createElement("p",null,n)))}function d(){return o?i.createElement("section",{className:m.features},i.createElement("div",{className:"container"},i.createElement("div",{className:"row"},o.map(((e,t)=>i.createElement(u,(0,n.Z)({key:t},e))))))):null}function g(){const{siteConfig:e}=(0,r.Z)(),t=e.customFields.bannerImage,a=!!t,n=a?{backgroundImage:`url("${t}")`}:null,s=(0,c.Z)("hero__title",{[m.titleOnBannerImage]:a}),o=(0,c.Z)("hero__subtitle",{[m.taglineOnBannerImage]:a});return i.createElement("header",{className:(0,c.Z)("hero",m.heroBanner),style:n},i.createElement("div",{className:"container"},i.createElement("h1",{className:s},e.title),i.createElement("p",{className:o},e.tagline),i.createElement("div",{className:m.buttons},i.createElement(l.Z,{className:"button button--secondary button--lg",to:"/docs/intro"},"Get Started \u2192"))))}function E(){const{siteConfig:e,tagline:t}=(0,r.Z)();return i.createElement(s.Z,{title:e.title,description:t},i.createElement(g,null),i.createElement("main",null,i.createElement(d,null),i.createElement("div",{className:"container"})))}}}]);