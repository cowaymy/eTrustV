package com.coway.trust.web.common.claim;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.session.ResultContext;
import org.apache.ibatis.session.ResultHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

public class ClaimFileHLBBHandler extends BasicTextDownloadHandler implements ResultHandler<Map<String, Object>> {
	private static final Logger LOGGER = LoggerFactory.getLogger(ClaimFileHLBBHandler.class);	
	
	// 헤더 작성을 위한 변수
	String inputDate = "";
	
	// 본문 작성을 위한 변수
	int counter = 1;
	String stextDetails = "";
	String sdrname = "";
	String sdraccno = "";
	String samt = "";
	String sdocno = "";
	//double fTotAmt = 0.0D;
	private BigDecimal fTotAmt = new BigDecimal(0);
	
	// footer 작성을 위한 변수
	String stext = "";
	String sbatchtot = "";
	String sbatchno = "";

	public ClaimFileHLBBHandler(FileInfoVO fileInfoVO, Map<String, Object> params) {
		super(fileInfoVO, params);
	}

	@Override
	public void handleResult(ResultContext<? extends Map<String, Object>> result) {
		try {
			if (!isStarted) {
				init();
				writeHeader();
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

	private void writeHeader() throws IOException {
		inputDate = CommonUtils.nvl(params.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String) params.get("ctrlBatchDt");
		LOGGER.debug("write Header complete.....");
	}

	private void writeBody(ResultContext<? extends Map<String, Object>> result) throws IOException {
		Map<String, Object> dataRow = result.getResultObject();
		
		try {
    		sdrname = (String.valueOf(dataRow.get("bankDtlDrName"))).length() > 40 ? 
    							(String.valueOf(dataRow.get("bankDtlDrName"))).substring(0, 40) : StringUtils.rightPad(String.valueOf(dataRow.get("bankDtlDrName")), 40, " ");
    
    		// ISSUE : 암호화 RULE 규정
    		// sdraccno = EncryptionProvider.Decrypt(det.AccNo.Trim()).Trim();
    		sdraccno = String.valueOf(dataRow.get("bankDtlDrAccNo")).trim();
    		samt = StringUtils.leftPad(CommonUtils.getNumberFormat(String.valueOf(dataRow.get("bankDtlAmt")), "0.00"),12, "0");        
            sdocno = (String.valueOf(dataRow.get("cntrctNOrdNo"))).trim();
            
    			stextDetails = StringUtils.leftPad(String.valueOf(counter), 3, "0") + ",EPY1000991,HLBB," + sdrname + "," + sdraccno + "," + samt + ",DR," + sdocno + "," + 
    					CommonUtils.changeFormat(CommonUtils.getAddDay(inputDate, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "dd/MM/yyyy");
    		
            
            //fTotAmt = fTotAmt + ((java.math.BigDecimal) dataRow.get("bankDtlAmt")).doubleValue();        
            fTotAmt = fTotAmt.add((java.math.BigDecimal) dataRow.get("bankDtlAmt"));
            
            out.write(stextDetails);
            out.newLine();
            out.flush();
            
            counter = counter + 1;
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
	}

	public void writeFooter() throws IOException {
		stext = "";
		
		try {
			sbatchtot = StringUtils.leftPad(CommonUtils.getNumberFormat(String.valueOf(fTotAmt), "0.00"), 12, "0");
			sbatchno = (CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "ddMMyy") + "01").trim();
		
			stext = StringUtils.leftPad(String.valueOf(counter), 3, "0") + ",EPY1000991,HLBB,"
					+ StringUtils.rightPad("WOONGJIN COWAY", 40, " ") + ",00100321782," + sbatchtot + ",CR," + sbatchno
					+ ","
					+ CommonUtils.changeFormat(CommonUtils.getAddDay(inputDate, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "dd/MM/yyyy");
		

    		out.write(stext);
    		out.newLine();
    		out.flush();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
