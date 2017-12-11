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

public class ClaimFileFPXHandler extends BasicTextDownloadHandler implements ResultHandler<Map<String, Object>> {
	private static final Logger LOGGER = LoggerFactory.getLogger(ClaimFileFPXHandler.class);	
	
	// 헤더 작성을 위한 변수
	String stext = "";
	String inputDate =  "";
	
	// 본문 작성을 위한 변수
	String sdocno = "";
	String sCrAccNo = "";
	String sDRBankID = "";
	String sdrbankBr = "";
	String sDrAccNo = "";
	String sDrName = "";
	String sNRIC = "";
	String samt = "";
	double itotamt = 0;
	long ihashVal = 0;
	long ihashtot = 0;
	int iTotalCnt = 0;
	
	

	public ClaimFileFPXHandler(FileInfoVO fileInfoVO, Map<String, Object> params) {
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
		// 헤더 작성
		inputDate = CommonUtils.nvl(params.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String) params.get("ctrlBatchDt");
		stext = "1" + StringUtils.rightPad("FPX", 6, " ") + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "dd/MM/yyyy") + "SE00000293" + "99";

		out.write(stext);
		out.newLine();
		out.flush();
		LOGGER.debug("write Header complete.....");
	}

	private void writeBody(ResultContext<? extends Map<String, Object>> result) throws IOException {
		Map<String, Object> dataRow = result.getResultObject();
		
		sdocno = StringUtils.rightPad(String.valueOf(dataRow.get("cntrctNOrdNo")), 20, " ");
		sCrAccNo = StringUtils.leftPad("21413800109431", 20, " ");
		sDRBankID = StringUtils.rightPad(String.valueOf(dataRow.get("fpxCode")), 10, " ");
		sdrbankBr = StringUtils.leftPad("111", 10, " ");

		// ISSUE : 암호화 RULE 규정
		// sDrAccNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).Trim().PadLeft(20,' ');
		sDrAccNo = StringUtils.leftPad(String.valueOf(dataRow.get("bankDtlDrAccNo")) , 20, " ");

		sDrName = (String.valueOf(dataRow.get("bankDtlDrName"))).trim().length() > 40 ? 
					(String.valueOf(dataRow.get("bankDtlDrName"))).trim().substring(0, 40) : StringUtils.rightPad((String.valueOf(dataRow.get("bankDtlDrName"))).trim(), 40, " ");

		sNRIC = (String.valueOf(dataRow.get("bankDtlDrNric"))).trim().length() > 20 ? 
					(String.valueOf(dataRow.get("bankDtlDrNric"))).trim().substring(0, 20) : StringUtils.rightPad((String.valueOf(dataRow.get("bankDtlDrNric"))).trim(), 20, " ");

		samt = StringUtils.leftPad(CommonUtils.getNumberFormat(String.valueOf(dataRow.get("bankDtlAmt")), "0.00"),12, " ");

		stext = "2" + sdocno + sCrAccNo + sDRBankID + sdrbankBr + sDrAccNo + sDrName + "1" + sNRIC + samt + "MYR" + StringUtils.rightPad("", 91, " ") + "99";

		itotamt = itotamt + (((java.math.BigDecimal) dataRow.get("bankDtlAmt")).doubleValue() * 100);

		ihashVal = (Long.parseLong(CommonUtils.right(sDrAccNo.trim(), 8)) * Long.parseLong(String.valueOf(((java.math.BigDecimal) dataRow.get("bankDtlAmt")).longValue() * 100)));
		ihashtot = ihashtot + Long.parseLong((CommonUtils.right(String.valueOf(ihashVal), 8)));
		iTotalCnt++;
		
		out.write(stext);
		out.newLine();
		out.flush();
	}	
	
	public void writeFooter() throws IOException {
		
		// footer 작성
		stext = "9" + StringUtils.leftPad(String.valueOf(iTotalCnt), 6, " ")
					+ StringUtils.leftPad(String.valueOf(itotamt), 15, " ")
					+ StringUtils.leftPad((String.valueOf(ihashtot)).trim(), 13, " ");

        out.write(stext);
        out.newLine();
        out.flush();
	}
}
