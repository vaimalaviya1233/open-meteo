import Foundation
import FlatBuffers
import OpenMeteo


extension Cmip6Domain: ModelFlatbufferSerialisable {
    typealias HourlyVariable = ForecastSurfaceVariable
    
    typealias HourlyPressureType = ForecastPressureVariableType
    
    typealias DailyVariable = Cmip6VariableOrDerivedPostBias
  
    static func encodeDaily(section: ApiSection<DailyVariable>, _ fbb: inout FlatBufferBuilder) -> Offset {
        let offsets = ForecastapiResult<Self>.encode(section: section, &fbb)
        let start = ClimateDaily.startClimateDaily(&fbb)
        ClimateDaily.add(time: section.timeFlatBuffers(), &fbb)
        for (variable, offset) in zip(section.columns, offsets) {
            switch variable.variable {
            case .raw(let v):
                switch v {
                case .raw(let v):
                    switch v {
                    case .temperature_2m_min:
                        ClimateDaily.add(temperature2mMin: offset, &fbb)
                    case .temperature_2m_max:
                        ClimateDaily.add(temperature2mMax: offset, &fbb)
                    case .temperature_2m_mean:
                        ClimateDaily.add(temperature2mMean: offset, &fbb)
                    case .pressure_msl_mean:
                        ClimateDaily.add(pressureMslMean: offset, &fbb)
                    case .cloudcover_mean:
                        ClimateDaily.add(cloudcoverMean: offset, &fbb)
                    case .precipitation_sum:
                        ClimateDaily.add(precipitationSum: offset, &fbb)
                    case .snowfall_water_equivalent_sum:
                        ClimateDaily.add(snowfallWaterEquivalentSum: offset, &fbb)
                    case .relative_humidity_2m_min:
                        ClimateDaily.add(relativeHumidity2mMin: offset, &fbb)
                    case .relative_humidity_2m_max:
                        ClimateDaily.add(relativeHumidity2mMax: offset, &fbb)
                    case .relative_humidity_2m_mean:
                        ClimateDaily.add(relativeHumidity2mMean: offset, &fbb)
                    case .windspeed_10m_mean:
                        ClimateDaily.add(windspeed10mMean: offset, &fbb)
                    case .windspeed_10m_max:
                        ClimateDaily.add(windspeed10mMax: offset, &fbb)
                    case .soil_moisture_0_to_10cm_mean:
                        ClimateDaily.add(soilMoisture0To10cmMean: offset, &fbb)
                    case .shortwave_radiation_sum:
                        ClimateDaily.add(shortwaveRadiationSum: offset, &fbb)
                    }
                case .derived(let v):
                    switch v {
                    case .et0_fao_evapotranspiration_sum:
                        ClimateDaily.add(et0FaoEvapotranspirationSum: offset, &fbb)
                    case .leaf_wetness_probability_mean:
                        ClimateDaily.add(leafWetnessProbabilityMean: offset, &fbb)
                    case .soil_moisture_0_to_100cm_mean:
                        ClimateDaily.add(soilMoisture0To100cmMean:  offset, &fbb)
                    case .soil_moisture_0_to_7cm_mean:
                        ClimateDaily.add(soilMoisture0To7cmMean: offset, &fbb)
                    case .soil_moisture_7_to_28cm_mean:
                        ClimateDaily.add(soilMoisture7To28cmMean: offset, &fbb)
                    case .soil_moisture_28_to_100cm_mean:
                        ClimateDaily.add(soilMoisture28To100cmMean: offset, &fbb)
                    case .soil_temperature_0_to_100cm_mean:
                        ClimateDaily.add(soilTemperature0To100cmMean: offset, &fbb)
                    case .soil_temperature_0_to_7cm_mean:
                        ClimateDaily.add(soilTemperature0To7cmMean: offset, &fbb)
                    case .soil_temperature_7_to_28cm_mean:
                        ClimateDaily.add(soilTemperature7To28cmMean: offset, &fbb)
                    case .soil_temperature_28_to_100cm_mean:
                        ClimateDaily.add(soilTemperature28To100cmMean: offset, &fbb)
                    case .vapor_pressure_deficit_max:
                        ClimateDaily.add(vaporPressureDeficitMax: offset, &fbb)
                    case .windgusts_10m_mean:
                        ClimateDaily.add(windgusts10mMean: offset, &fbb)
                    case .windgusts_10m_max:
                        ClimateDaily.add(windgusts10mMax: offset, &fbb)
                    }
                }
            case .derived(let v):
                switch v {
                case .snowfall_sum:
                    ClimateDaily.add(snowfallSum: offset, &fbb)
                case .rain_sum:
                    ClimateDaily.add(rainSum: offset, &fbb)
                case .dewpoint_2m_max:
                    ClimateDaily.add(dewpoint2mMax: offset, &fbb)
                case .dewpoint_2m_min:
                    ClimateDaily.add(dewpoint2mMin: offset, &fbb)
                case .dewpoint_2m_mean:
                    ClimateDaily.add(dewpoint2mMean: offset, &fbb)
                case .growing_degree_days_base_0_limit_50:
                    ClimateDaily.add(growingDegreeDaysBase0Limit50: offset, &fbb)
                case .soil_moisture_index_0_to_10cm_mean:
                    ClimateDaily.add(soilMoistureIndex0To10cmMean: offset, &fbb)
                case .soil_moisture_index_0_to_100cm_mean:
                    ClimateDaily.add(soilMoistureIndex0To100cmMean: offset, &fbb)
                case .daylight_duration:
                    ClimateDaily.add(daylightDuration: offset, &fbb)
                case .windspeed_2m_max:
                    ClimateDaily.add(windspeed2mMax: offset, &fbb)
                case .windspeed_2m_mean:
                    ClimateDaily.add(windspeed2mMean: offset, &fbb)
                }
            }
        }
        return ClimateDaily.endClimateDaily(&fbb, start: start)
    }
    
    static func writeToFlatbuffer(section: ForecastapiResult<Self>.PerModel, _ fbb: inout FlatBufferBuilder, timezone: TimezoneWithOffset, fixedGenerationTime: Double?) throws {
        let generationTimeStart = Date()
        let daily = (try section.daily?()).map { encodeDaily(section: $0, &fbb) } ?? Offset()
        let generationTimeMs = fixedGenerationTime ?? (Date().timeIntervalSince(generationTimeStart) * 1000)
        
        let result = ClimateApiResponse.createClimateApiResponse(
            &fbb,
            latitude: section.latitude,
            longitude: section.longitude,
            elevation: section.elevation ?? .nan,
            model: section.model.flatBufferModel,
            generationtimeMs: Float32(generationTimeMs),
            dailyOffset: daily
        )
        fbb.finish(offset: result, addPrefix: true)
    }
    
    var flatBufferModel: ClimateModel {
        switch self {
        case .CMCC_CM2_VHR4:
            return .cmccCm2Vhr4
        case .FGOALS_f3_H_highresSST:
            return .fgoalsF3HHighressst
        case .FGOALS_f3_H:
            return .fgoalsF3H
        case .HiRAM_SIT_HR:
            return .hiramSitHr
        case .MRI_AGCM3_2_S:
            return .mriAgcm32S
        case .EC_Earth3P_HR:
            return .ecEarth3pHr
        case .MPI_ESM1_2_XR:
            return .mpiEsm12Xr
        case .NICAM16_8S:
            return .nicam168s
        }
    }
}