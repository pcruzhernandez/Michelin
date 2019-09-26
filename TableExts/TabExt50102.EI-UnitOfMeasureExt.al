tableextension 50102 "EI-UnitOfMeasureExt" extends "Unit of Measure"
{
    fields
    {
        field(50100; "DIAN Code"; Code[10])
        {
            TableRelation = "EI-UnitOfMeasure";
        }
    }
}