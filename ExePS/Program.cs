using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;

namespace ExePS
{
    class Program
    {
        static void Main(string[] args)
        {

            ////YOUR INPUT HERE
            //The code you used for Protecting the PS Script. Read Guide for details.
            string protectionCode = "gT4XPfvcJmHkQ5tYjY3fNgi7uwG4FB9j";
            //The Filename of the Protected Script. This File should be put in the Files folder of the Project with "Embeded Resource" build action.
            string protectedPSFileName = "WPF.txt";


            //string AppFolderUser = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);
            string AppFolderUser = Directory.GetCurrentDirectory();
            string progFolder = AppFolderUser + @"\PS";
            if (!(Directory.Exists(progFolder)))
            {
                System.IO.Directory.CreateDirectory(progFolder);
                Extract("ExePS", progFolder, "Files", @"Start.bat");
                Extract("ExePS", progFolder, "Files", @"Launcher.ps1");

                //Change WPF.txt to the File you produced with Encrypt_Decrypt.ps1. 
                //The file added to the Files Folder and the Build action should be "Embedded Resource"
                Extract("ExePS", progFolder, "Files", protectedPSFileName);
            }

            ProcessStartInfo startInfo = new ProcessStartInfo();
            startInfo.UseShellExecute = false;
            startInfo.FileName = progFolder + @"\Start.bat";
            startInfo.WindowStyle = ProcessWindowStyle.Hidden;
            startInfo.CreateNoWindow = true;
            startInfo.Arguments = "\"" + protectionCode + "\"" + " " + "\"" + protectedPSFileName + "\"";

            using (Process exeProcess = Process.Start(startInfo))
            {
                exeProcess.WaitForExit();
            }
        }

        public static void Extract(string nameSpace, string outDirectory, string internalFilePath, string resourceName)
        {
            Assembly assembly = Assembly.GetCallingAssembly();

            using (Stream s = assembly.GetManifestResourceStream(nameSpace + "." + (internalFilePath == "" ? "" : internalFilePath + ".") + resourceName))
            using (BinaryReader r = new BinaryReader(s))
            using (FileStream fs = new FileStream(outDirectory + "\\" + resourceName, FileMode.OpenOrCreate))
            using (BinaryWriter w = new BinaryWriter(fs))
            {
                w.Write(r.ReadBytes((int)s.Length));
            }
        }
    }
}
