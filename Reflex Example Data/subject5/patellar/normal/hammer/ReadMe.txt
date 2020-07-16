This is an export of data for a single Recording from a single Subject
within your Study from the MC10 Cloud. This data is contained in
the CSV file(s) contained in this zip archive.

### CSV File Formats:

#### gyro.csv
- Gyroscope Output
- Time in GMT Unix Epoch microseconds
- Gyroscope values in degrees per second
- Header row "Timestamp (microseconds),Gyro X (°/s),Gyro Y (°/s),Gyro Z (°/s)"
- Example data: "1458217123808462,2.32433211233211193,1.34474969474969441,1.031379731379734"

#### accel.csv
- Accelerometer values
- Time in GMT Unix Epoch microseconds
- Acceleration values in G's
- Header row "Timestamp (microseconds),Accel X (g),Accel Y (g),Accel Z (g)"
- Example data: "1458217123808462,0.11233211233211193,0.09474969474969441,1.1731379731379734"

#### elec.csv
- Electrode values
- Time in GMT Unix Epoch microseconds
- Voltages values in Volts
- Header row "Timestamp (microseconds), Sample (V)"
- Example data: "1458217123808462,0.0710072226036978"

### XXXX-errors.csv
- may be accel-errors.csv, gyro-errors.csv, elec-errors.csv
- Time in GMT Unix Epoch microseconds
- Header row "Timestamp (microseconds),Reason"
- Example data: "1482329518825214,EMPTY_SAMPLE"

## Plotting Examples

See github.com/MC10Inc/biostamp_rc for plotting examples of all data types.
