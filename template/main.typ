#import "@preview/saar-lst-thesis:0.1.0": *
#import "@preview/pergamon:0.8.0": *

// Use "de" for German template labels.
#set text(lang: "en")

#show: lst.with(
  title: "Thesis Title",
  author: "Your Name",
  matriculation-number: "Your Matriculation Number",
  supervisors: (
    ("Supervisors", "First Supervisor", "Second Supervisor"),
    ("Additional advisor", "Additional Advisor"),
  ),
  date: "Submission Date",

  abstract: [
    Write your abstract here.
  ],

  acknowledgments: [
    Write optional acknowledgments here, or remove this argument.
  ]
)

#add-bib-resource(read("custom.bib"))

= Introduction

Start writing your thesis here.

= Background

Many interesting combinatorial problems are NP-complete #cite("GareyJohnsonBook").

#citet("bender-koller-2020-climbing") argued that meaning cannot be learned from form alone.

= My Contribution

= Conclusion

#print-lst-bibliography()
