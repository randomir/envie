#!/usr/bin/env python
import os
import sys
sys.path.append(os.pardir)

import unittest
from utils import readlink, realpath


class TestUtils(unittest.TestCase):
    def setUp(self):
        os.chdir("/tmp")
        self.linkpath = os.tempnam("/tmp")
        os.symlink("/tmp", self.linkpath)


    # readlink

    def test_readlink_abs(self):
        self.assertEqual(readlink("test"), "/tmp/test")

    def test_readlink_sym(self):
        self.assertEqual(readlink(self.linkpath), "/tmp")

    def test_readlink_sym_missing(self):
        self.assertEqual(readlink(self.linkpath+"/some/other"), "/tmp/some/other")

    def test_readlink_sym_missing_norm(self):
        self.assertEqual(readlink(self.linkpath+"/some/../other"), "/tmp/other")

    def test_readlink_norm(self):
        self.assertEqual(readlink("a/../b"), "/tmp/b")

    def test_readlink_abs_norm(self):
        self.assertEqual(readlink("/a/../c"), "/c")


    # realpath

    def test_realpath_abs(self):
        self.assertEqual(realpath("test"), "/tmp/test")

    def test_realpath_rel(self):
        self.assertEqual(realpath("test/", "/"), "tmp/test")

    def test_realpath_abs_norm(self):
        self.assertEqual(realpath("test/../../../../"), "/")

    def test_realpath_rel_norm(self):
        self.assertEqual(realpath("test/../../../../", "/"), ".")

    def test_realpath_rel2(self):
        self.assertEqual(realpath(".", "/etc"), "../tmp")

    def test_realpath_rel3(self):
        self.assertEqual(realpath("..", "/etc"), "..")

    def test_realpath_rel4(self):
        self.assertEqual(realpath("a/b", "/etc"), "../tmp/a/b")

    def test_realpath_sym(self):
        self.assertEqual(realpath(self.linkpath, "/etc"), "../tmp")



if __name__ == '__main__':
    unittest.main()
