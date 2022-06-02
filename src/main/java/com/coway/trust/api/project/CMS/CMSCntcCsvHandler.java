package com.coway.trust.api.project.CMS;

import java.io.IOException;
import java.util.Map;

import org.apache.ibatis.session.ResultContext;
import org.apache.ibatis.session.ResultHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.web.common.claim.FileInfoVO;

public class CMSCntcCsvHandler extends CmsTextDownloadHandler implements ResultHandler<Map<String, Object>> {

    public static final Logger LOGGER = LoggerFactory.getLogger(CMSCntcCsvHandler.class);

    String text = "";
    String id = "";
    String type = "";
    String memCodeId = "";
    String cntcId = "";
    String addId = "";
    String ordCat = "";
    String name = "";
    String dob = "";
    String mobileNo = "";
    String officeNo = "";
    String residenceNo = "";
    String email = "";
    String subType = "";
    String corpType = "";
    String address = "";
    String cnty = "";
    String postCode = "";
    String crtDt = "";
    String updDt = "";

    final String separator = "\",\"";

    public CMSCntcCsvHandler(FileInfoVO fileInfoVO, Map<String, Object> params) {
        super(fileInfoVO, params);
    }

    @Override
    public void handleResult(ResultContext<? extends Map<String, Object>> result) {
        try {
            if (!isStarted) {
                init();
                isStarted = true;
            }

            writeBody(result);

        } catch (Exception e) {
            throw new ApplicationException(e, AppConstants.FAIL);
        }
    }

    private void init() throws IOException {
        out = createFile();
    }

    private void writeBody(ResultContext<? extends Map<String, Object>> result) throws IOException {
        Map<String, Object> dataRow = result.getResultObject();

        id = String.valueOf(dataRow.get("id")).trim();
        type = String.valueOf(dataRow.get("type")).trim();
        memCodeId = String.valueOf(dataRow.get("memCodeId")).trim();
        cntcId = String.valueOf(dataRow.get("memCodeId")).trim();
        addId = String.valueOf(dataRow.get("addId")).trim();
        ordCat = String.valueOf(dataRow.get("ordCat")).trim();
        name = String.valueOf(dataRow.get("name")).trim();
        dob = String.valueOf(dataRow.get("dob")).trim();
        mobileNo = String.valueOf(dataRow.get("mobileNo")).trim();
        officeNo = String.valueOf(dataRow.get("officeNo")).trim();
        residenceNo = String.valueOf(dataRow.get("residenceNo")).trim();
        email = String.valueOf(dataRow.get("email")).trim();
        subType = String.valueOf(dataRow.get("subType")).trim();
        corpType = String.valueOf(dataRow.get("corpType")).trim();
        address = String.valueOf(dataRow.get("address")).trim();
        cnty = String.valueOf(dataRow.get("cnty")).trim();
        postCode = String.valueOf(dataRow.get("postCode")).trim();
        crtDt = String.valueOf(dataRow.get("crtDt")).trim();
        updDt = String.valueOf(dataRow.get("updDt")).trim();

        text = "\"" + id + separator + type + separator + memCodeId + separator + cntcId + separator + addId + separator +
               ordCat + separator + name + separator + dob + separator + mobileNo + separator + officeNo + separator +
               residenceNo + separator + email + separator + subType + separator + corpType + separator + address + separator +
               cnty + separator + postCode + separator + crtDt + separator + updDt + "\"";

        out.write(text);
        out.newLine();
        out.flush();
    }
}
