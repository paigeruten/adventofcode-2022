File do(
    openAndReadLines := method(path,
        file := File clone openForReading(path)
        lines := file readLines
        file close
        return lines
    )
)
