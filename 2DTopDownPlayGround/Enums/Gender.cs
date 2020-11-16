namespace DTopDownPlayGround.Enums
{
    public enum Gender
    {
        Male,
        Female
    }

    public static class GenderEnumExtensions
    {
        public static bool CanHaveSexWith(this Gender thisGender, Gender otherGender)
        {
            return thisGender != otherGender;
        }
    }
}