#!/usr/bin/env python

"""
    python tkinter needed.
    e.g.:
        $ sudo apt-get install python-tk

    copy this file to:
        linux....: ~/DrQueue_env/
        windows..: %APPDATA%\DrQueue_env\
"""

from __future__ import print_function

import os
import sys
import subprocess

try:
    # Python 3
    import tkinter
    from tkinter import filedialog
    from tkinter import messagebox
except ImportError:
    # Python 2
    import Tkinter as tkinter
    import tkFileDialog as filedialog
    import tkMessageBox as messagebox


FILE_INFO={
    ".blend":"blender",
    ".max":"3dsmax",
}
FILEDIALOG_SCENE_FILTER = (
    ("All files", "*.*"),
    ("Scene", ";".join(["*%s" % i for i in FILE_INFO.keys()])),
)
# http://www.python-forum.de/viewtopic.php?f=18&t=36806 (de)
FILEDIALOG_SCENE_FILTER += tuple([(v,"*%s" % k) for k,v in FILE_INFO.items()])

print(FILEDIALOG_SCENE_FILTER)
# import sys;sys.exit()







class BaseWindow(object):
    title = ""

    def __init__(self):
        self.root = tkinter.Tk()
        self.root.geometry("+%d+%d" % (
            self.root.winfo_screenwidth() * 0.1, self.root.winfo_screenheight() * 0.1
        ))
        self.root.title(self.title)

    def mainloop(self):
        self.root.mainloop()


class SubmitJob(BaseWindow):
    title = "Submit Network render job"
    DEFAULT_CLI_ARGS = "-v --no-ssh"

    def __init__(self):
        super(SubmitJob, self).__init__()

        self.root.columnconfigure(0, weight=1)
        self.root.rowconfigure(0, weight=1)

        _row = 0

        self.scene_frame = tkinter.Frame(self.root)
        self.scene_frame.grid(row=_row, column=0, sticky=tkinter.W)

        self.scene_var = tkinter.StringVar()
        self.scene_entry = tkinter.Entry(self.scene_frame, width=100, textvariable=self.scene_var)
        self.scene_entry.grid(column=0, row=0, sticky=tkinter.W)
        tkinter.Button(
            self.scene_frame, text="choose", command=self.choose_scene
        ).grid(column=1, row=0, sticky=tkinter.W)

        _row += 1

        self.job_name_frame = tkinter.Frame(self.root)
        self.job_name_frame.grid(row=_row, column=0, sticky=tkinter.W)

        tkinter.Label(self.job_name_frame, text="job name:").grid(column=0, row=0, sticky=tkinter.W)

        self.job_name_var = tkinter.StringVar()
        self.job_name_entry = tkinter.Entry(self.job_name_frame, width=50, textvariable=self.job_name_var)
        self.job_name_entry.grid(column=1, row=0, sticky=tkinter.W)
        
        _row += 1

        self.args_frame = tkinter.Frame(self.root)
        self.args_frame.grid(row=_row, column=0, sticky=tkinter.W)

        tkinter.Label(self.args_frame, text="drqueue cli args:").grid(column=0, row=0, sticky=tkinter.W)

        self.args_var = tkinter.StringVar(value=self.DEFAULT_CLI_ARGS)
        self.args_entry = tkinter.Entry(self.args_frame, width=50, textvariable=self.args_var)
        self.args_entry.grid(column=1, row=0, sticky=tkinter.W)

        _row += 1

        self.range_frame = tkinter.Frame(self.root)
        self.range_frame.grid(row=_row, column=0, sticky=tkinter.W)

        tkinter.Label(self.range_frame, text="Start Frame:").grid(column=0, row=0, sticky=tkinter.W)
        self.from_frame_var = tkinter.StringVar(value="1")
        self.from_frame_entry = tkinter.Entry(self.range_frame, width=10, textvariable=self.from_frame_var)
        self.from_frame_entry.grid(column=1, row=0, sticky=tkinter.W)

        tkinter.Label(self.range_frame, text="End Frame:").grid(column=2, row=0, sticky=tkinter.W)
        self.to_frame_var = tkinter.StringVar(value="100")
        self.to_frame_entry = tkinter.Entry(self.range_frame, width=10, textvariable=self.to_frame_var)
        self.to_frame_entry.grid(column=3, row=0, sticky=tkinter.W)

        tkinter.Label(self.range_frame, text="Every Nth Frame:").grid(column=4, row=0, sticky=tkinter.W)
        self.nth_frame_var = tkinter.StringVar(value="1")
        self.nth_frame_entry = tkinter.Entry(self.range_frame, width=10, textvariable=self.nth_frame_var)
        self.nth_frame_entry.grid(column=5, row=0, sticky=tkinter.W)

        _row += 1

        self.button_frame = tkinter.Frame(self.root)
        self.button_frame.grid(row=_row, column=0, sticky=tkinter.W)

        tkinter.Button(
            master=self.button_frame, text='submit', command=self.submit
        ).grid(column=0, row=0, sticky=tkinter.W)
        tkinter.Button(
            master=self.button_frame,text='Quit', command=self.root.quit
        ).grid(column=1, row=0, sticky=tkinter.W)

    def choose_scene(self):
        new_scene = filedialog.askopenfilename(
            parent=self.root,
            title="Select a scene file",
            filetypes=FILEDIALOG_SCENE_FILTER,
            # initialdir=self.current_dir, # TODO: use last used dir
        )
        self.scene_var.set(new_scene)

        basename = os.path.basename(new_scene)
        filename = os.path.splitext(basename)[0]
        self.job_name_var.set(filename)


    def submit(self):
        try:
            from_frame=int(self.from_frame_var.get())
            to_frame=int(self.to_frame_var.get())
            nth_frame=int(self.nth_frame_var.get())
        except ValueError, err:
            messagebox.showinfo("ERROR",
                "Error in from/to/nth frame values: %s" % err
            )
            return

        scene = self.scene_entry.get()
        if not scene:
            messagebox.showinfo("ERROR",
                "Please choose a scene file first."
            )
            return

        if not os.path.isfile(scene):
            messagebox.showinfo("ERROR",
                "Given scene file %r doesn't exist." % scene
            )
            return

        job_name = self.job_name_var.get()
        if not job_name:
            messagebox.showinfo("ERROR",
                "Please set a job name first."
            )
            return

        cli_args = self.args_entry.get()
        print("cli args:", cli_args)
        print("sumbit scene:", scene)

        ext = os.path.splitext(scene)[1]
        try:
            renderer = FILE_INFO[ext]
        except KeyError:
            messagebox.showinfo("ERROR",
                "Unknown render filetype: %r" % ext
            )
            return
        print("renderer:", renderer)

        popenargs = ["drqueue"]
        popenargs += self.args_var.get().split(" ")
        popenargs += [
            # "job", "add",
            "job add",
            # "--name", job_name,
            # "--startframe", "%s" % from_frame,
            # "--endframe", "%s" % to_frame,
            # "--blocksize", "%s" % nth_frame,
            # "--renderer", renderer,
            # "--scenefile", scene,

            "--name=%s" % job_name,
            "--startframe=%s" % from_frame,
            "--endframe=%s" % to_frame,
            "--blocksize=%s" % nth_frame,
            "--renderer=%s" %renderer,
            "--scenefile=%s" % scene,

        ]
        print("Call drqueue with:")
        print("-"*79)
        print(repr(popenargs))
        print("-"*79)
        print(" ".join(popenargs))
        print("-"*79)

        try:
            output = subprocess.check_output(popenargs, shell=True, universal_newlines=True, stderr=subprocess.STDOUT)
        except subprocess.CalledProcessError as err:
            msg = (
                "Error calling drqueue cli:\n"
                "----------------------------------\n"
                "%s\n"
                "----------------------------------\n"
            ) % err.output
            print(msg)
            messagebox.showinfo("ERROR",msg)
            return

        msg = (
            "DrQueue cli output:\n"
            "----------------------------------\n"
            "%s\n"
            "----------------------------------\n"
        ) % output
        print(msg)
        messagebox.showinfo("Submitted", msg)



if __name__ == "__main__":
    gui = SubmitJob()
    gui.mainloop()