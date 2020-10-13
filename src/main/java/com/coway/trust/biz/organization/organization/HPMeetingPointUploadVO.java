package com.coway.trust.biz.organization.organization;

import org.apache.commons.csv.CSVRecord;

public class HPMeetingPointUploadVO {

    private String memCode;
    private String memName;
    private String meetpoint;

    public static HPMeetingPointUploadVO create(CSVRecord CSVRecord) {
        HPMeetingPointUploadVO vo = new HPMeetingPointUploadVO();

        vo.setMemCode(CSVRecord.get(0).trim());
        vo.setMemName(CSVRecord.get(1).trim());
        vo.setMeetpoint(CSVRecord.get(2).trim());

        return vo;
    }

    public String getMemCode() {
        return memCode;
    }

    public void setMemCode(String memCode) {
        this.memCode = memCode;
    }

    public String getMemName() {
        return memName;
    }

    public void setMemName(String memName) {
        this.memName = memName;
    }

    public String getMeetpoint() {
        return meetpoint;
    }

    public void setMeetpoint(String meetpoint) {
        this.meetpoint = meetpoint;
    }
}
