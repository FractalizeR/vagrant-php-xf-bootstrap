# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# This project is maintained by:
#  _    ____          ___      __               ____             __
# | |  / / /___ _____/ (_)____/ /___ __   __   / __ \____ ______/ /________  ___________  __  ____  __
# | | / / / __ `/ __  / / ___/ / __ `/ | / /  / /_/ / __ `/ ___/ __/ ___/ / / / ___/ __ \/ / / / / / /
# | |/ / / /_/ / /_/ / (__  ) / /_/ /| |/ /  / _, _/ /_/ (__  ) /_/ /  / /_/ (__  ) / / / /_/ / /_/ /
# |___/_/\__,_/\__,_/_/____/_/\__,_/ |___/  /_/ |_|\__,_/____/\__/_/   \__,_/____/_/ /_/\__, /\__, /
#                                                                                   /____//____/
#
# Email: FractalizeR@yandex.ru, vladislav.rastrusny@gmail.com
# http://www.fractalizer.ru
#
# This work is licensed under the Apache 2.0
# United States License. To view a copy of this license, visit
# http://www.apache.org/licenses/LICENSE-2.0
# or send a letter to The Apache Software Foundation Dept. 9660 Los Angeles, CA 90084-9660 U.S.A.
#

module OSDetect
  def OSDetect.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OSDetect.mac?
   (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OSDetect.unix?
    !OS.windows?
  end

  def OSDetect.linux?
    OS.unix? and not OS.mac?
  end
end
