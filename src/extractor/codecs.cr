module Codecs
  # https://en.wikipedia.org/wiki/YouTube#Quality_and_formats
  # update at 2017-04-22
  TITLE  = ["itag", "container", "video_resolution", "video_encoding", "video_profile", "video_bitrate", "audio_encoding", "audio_bitrate"]
  CODECS = String.build do |codecs|
    # Non-DASH
    codecs << <<-EOF
    |  17 |  3GP |        144p | MPEG-4 Visual |    Simple |      0.05 |      AAC |  24 |
    |  18 |  MP4 |        360p |         H.264 |  Baseline |       0.5 |      AAC |  96 |
    |  22 |  MP4 |        720p |         H.264 |      High |     42769 |      AAC | 192 |
    |  36 |  3GP |        240p | MPEG-4 Visual |    Simple |     0.175 |      AAC |  32 |
    |  43 | WebM |        360p |           VP8 |       N/A |  0.5-0.75 |   Vorbis | 128 |

    EOF

    # DASH - video only
    codecs << <<-EOF
    | 133 |  MP4 |        240p |         H.264 |      Main |   0.2–0.3 |          |     |
    | 134 |  MP4 |        360p |         H.264 |      Main |   0.3–0.4 |          |     |
    | 135 |  MP4 |        480p |         H.264 |      Main |     0.5–1 |          |     |
    | 136 |  MP4 |        720p |         H.264 |      Main |     1–1.5 |          |     |
    | 137 |  MP4 |       1080p |         H.264 |      High |     2.5–3 |          |     |
    | 138 |  MP4 |       4320p |         H.264 |      High |   13.5–25 |          |     |
    | 160 |  MP4 | 144p 15 fps |         H.264 |      Main |       0.1 |          |     |
    | 242 | WebM |        240p |           VP9 | Profile 0 |   0.1–0.2 |          |     |
    | 243 | WebM |        360p |           VP9 | Profile 0 |      0.25 |          |     |
    | 244 | WebM |        480p |           VP9 | Profile 0 |       0.5 |          |     |
    | 247 | WebM |        720p |           VP9 | Profile 0 |   0.7–0.8 |          |     |
    | 248 | WebM |       1080p |           VP9 | Profile 0 |       1.5 |          |     |
    | 264 |  MP4 |       1440p |         H.264 |      High |     4–4.5 |          |     |
    | 266 |  MP4 |       2160p |         H.264 |      High |   12.5–16 |          |     |
    | 271 | WebM |       1440p |           VP9 | Profile 0 |         9 |          |     |
    | 272 | WebM |       4320p |           VP9 | Profile 0 |     20–25 |          |     |
    | 278 | WebM | 144p 15 fps |           VP9 | Profile 0 |      0.08 |          |     |
    | 298 |  MP4 |    720p HFR |         H.264 |      Main |     3–3.5 |          |     |
    | 299 |  MP4 |   1080p HFR |         H.264 |      High |       5.5 |          |     |
    | 302 | WebM |    720p HFR |           VP9 | Profile 0 |       2.5 |          |     |
    | 303 | WebM |   1080p HFR |           VP9 | Profile 0 |         5 |          |     |
    | 308 | WebM |   1440p HFR |           VP9 | Profile 0 |        10 |          |     |
    | 313 | WebM |       2160p |           VP9 | Profile 0 |     13–15 |          |     |
    | 315 | WebM |   2160p HFR |           VP9 | Profile 0 |     20–25 |          |     |
    | 330 | WebM |    144p HDR |           HFR |       VP9 | Profile 2 |     0.08 |     |
    | 331 | WebM |    240p HDR |           HFR |       VP9 | Profile 2 | 0.1–0.15 |     |
    | 332 | WebM |    360p HDR |           HFR |       VP9 | Profile 2 |     0.25 |     |
    | 333 | WebM |    480p HDR |           HFR |       VP9 | Profile 2 |      0.5 |     |
    | 334 | WebM |    720p HDR |           HFR |       VP9 | Profile 2 |        1 |     |
    | 335 | WebM |   1080p HDR |           HFR |       VP9 | Profile 2 |    1.5–2 |     |
    | 336 | WebM |   1440p HDR |           HFR |       VP9 | Profile 2 |      5–7 |     |
    | 337 | WebM |   2160p HDR |           HFR |       VP9 | Profile 2 |    12–14 |     |

    EOF

    # DASH - audio only
    codecs << <<-EOF
    | 140 |  M4A |             |               |           |           |      AAC | 128 |
    | 171 | WebM |             |               |           |           |   Vorbis | 128 |
    | 249 | WebM |             |               |           |           |     Opus |  48 |
    | 250 | WebM |             |               |           |           |     Opus |  64 |
    | 251 | WebM |             |               |           |           |     Opus | 160 |

    EOF

    # live stream
    codecs << <<-EOF
    |  91 |   TS |        144p |         H.264 |      Main |       0.1 |      AAC |  48 |
    |  92 |   TS |        240p |         H.264 |      Main |  0.15–0.3 |      AAC |  48 |
    |  93 |   TS |        360p |         H.264 |      Main |     0.5–1 |      AAC | 128 |
    |  94 |   TS |        480p |         H.264 |      Main |  0.8–1.25 |      AAC | 128 |
    |  95 |   TS |        720p |         H.264 |      Main |     1.5–3 |      AAC | 256 |
    |  96 |   TS |       1080p |         H.264 |      High |     2.5–6 |      AAC | 256 |
    EOF
  end

  extend self

  def format(itag : String)
    CODECS.each_line do |line|
      line = line[1..-2].split("|").map { |x| x.strip }
      if line[0] == itag
        comment = "default"
        comment = "video only"  if line[6].empty?
        comment = "audio only"  if line[2].empty?
        comment = "live stream" if line[1] == "TS"
        return {
          itag:             line[0],
          container:        line[1],
          video_resolution: line[2],
          video_encoding:   line[3],
          video_profile:    line[4],
          video_bitrate:    line[5],
          audio_encoding:   line[6],
          audio_bitrate:    line[7],
          comment:          comment,
        }
      end
    end
    return nil
  end
end
