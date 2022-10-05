using PowerPoint = Microsoft.Office.Interop.PowerPoint;
using Microsoft.Office.Interop.PowerPoint;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace slide_speaker_add_in
{
    public partial class ThisAddIn
    {
        private static readonly HttpClient client = new HttpClient();

        private void ThisAddIn_Startup(object sender, System.EventArgs e)
        {
            Application.SlideShowNextSlide
                += new PowerPoint.EApplication_SlideShowNextSlideEventHandler
                (
                    ThisAddIn_SlideShowNextSlideEventHandler
                );
        }

        private void ThisAddIn_Shutdown(object sender, System.EventArgs e)
        {
        }

        private void ThisAddIn_SlideShowNextSlideEventHandler(SlideShowWindow Wn)
        {
            var i = Wn.View.CurrentShowPosition;
            var subjectString = Wn.Presentation.Slides[i].NotesPage.Shapes[2].TextFrame.TextRange.Text;
            var tag = GetTransitionTag(subjectString);

            if (!string.IsNullOrEmpty(tag))
            {
                _ = PublishTagAsync(tag);
            }
        }

        public async Task PublishTagAsync(string tag)
        {
            var requestUri = "http://W10-D-24.celc.christpewaukee.org:3000/slide";
            var values = new Dictionary<string, string>
            {
                { "tag", tag }
            };

            var content = new FormUrlEncodedContent(values);

            try
            {
                var response = await client.PostAsync(requestUri, content);

                _ = await response.Content.ReadAsStringAsync();
            }
            catch (System.Net.Http.HttpRequestException e)
            {
                MessageBox.Show(e.Message);
            }
        }

        private string GetTransitionTag(string subjectString)
        {
            var regex = new Regex(@"\[.*\]");
            var myMatches = regex.Matches(subjectString);

            string GetTransitionTagRet = default;
            if (myMatches.Count > 0)
            {
                GetTransitionTagRet = myMatches[0].Value;
            }

            return GetTransitionTagRet;
        }        

        #region VSTO generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InternalStartup()
        {
            this.Startup += new System.EventHandler(ThisAddIn_Startup);
            this.Shutdown += new System.EventHandler(ThisAddIn_Shutdown);
        }
        
        #endregion
    }
}
