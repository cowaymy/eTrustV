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

public class ClaimFileBSNHandler extends BasicTextDownloadHandler implements ResultHandler<Map<String, Object>> {
	private static final Logger LOGGER = LoggerFactory.getLogger(ClaimFileBSNHandler.class);	
	
	// 헤더 작성을 위한 변수
	String sText = "";
	String sorigid = "";
	String senrdate = "";
	String sorgacc = "";	
	
	// 본문 작성을 위한 변수
	int counter = 1;
	long iHashTot = 0;
	String stextDetails = "";
	String sLimit = "";
	String sDrAccNo = "";
	String sDocno = "";
	String sNRIC = "";
	String sMNric = "";
	double iTotalAmt = 0;
	int iTotalCnt = 0;
	
	// footer 작성을 위한 변수
	String fText = "";
	
	

	public ClaimFileBSNHandler(FileInfoVO fileInfoVO, Map<String, Object> params) {
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
		
		sorigid = "M4743600";
		senrdate = CommonUtils.getNowDate();;
		sorgacc = "1410029000510851";
		sText = sorigid + senrdate + "29755" + "0000000" + sorgacc + StringUtils.leftPad("", 76, " ");

		out.write(sText);
		out.newLine();
		out.flush();
				
		LOGGER.debug("write Header complete.....");
	}

	private void writeBody(ResultContext<? extends Map<String, Object>> result) throws IOException {
		Map<String, Object> dataRow = result.getResultObject();
		
		// 본문 작성
		sLimit = StringUtils.leftPad(String.valueOf(((java.math.BigDecimal) dataRow.get("bankDtlAmt")).longValue() * 100), 15, "0");

		// 암호화는 나중에 하자
		// ISSUE : 암호화 RULE 규정
		// sDrAccNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).PadRight(16,' ');
		sDrAccNo = StringUtils.leftPad(String.valueOf(dataRow.get("bankDtlDrAccNo")).trim(), 16, " ");
		
		sDocno = StringUtils.rightPad(String.valueOf(dataRow.get("cntrctNOrdNo")), 20, " ");
		sNRIC = StringUtils.rightPad(String.valueOf(dataRow.get("bankDtlDrNric")), 12, " ");

		if (sNRIC.trim().length() != 12) {
			sMNric = (String.valueOf(dataRow.get("bankDtlDrNric"))).trim().length() > 8 ? 
								(String.valueOf(dataRow.get("bankDtlDrNric"))).trim().substring(0, 8) : StringUtils.rightPad((String.valueOf(dataRow.get("bankDtlDrNric"))).trim(), 8, " ");
		}

		iTotalAmt = iTotalAmt + ((java.math.BigDecimal) dataRow.get("bankDtlAmt")).doubleValue();

		if ((String.valueOf(dataRow.get("bankDtlDrNric"))).trim().length() == 12) {
			stextDetails = sorigid + senrdate + "29755" + StringUtils.leftPad(String.valueOf(counter), 7, "0")
									+ sLimit + sDrAccNo + "A100" + StringUtils.rightPad("", 4, " ") + sDocno
									+ StringUtils.rightPad("", 12, " ") + sNRIC + StringUtils.rightPad("", 8, " ") + " ";
		} else {
			stextDetails = sorigid + senrdate + "29755" + StringUtils.leftPad(String.valueOf(counter), 7, "0")
					+ sLimit + sDrAccNo + "A100" + StringUtils.rightPad("", 4, " ") + sDocno
					+ StringUtils.rightPad("", 12, " ") + StringUtils.rightPad("", 12, " ") + sMNric + " ";
		}

		iHashTot = iHashTot + Long.parseLong(CommonUtils.right(sDrAccNo.trim(), 4));

		out.write(stextDetails);
		out.newLine();
		out.flush();

		counter = counter + 1;
		iTotalCnt++;
	}

	public void writeFooter() throws IOException {
		
		fText = sorigid + senrdate + "29755" + "9999999" + StringUtils.leftPad(String.valueOf(iTotalAmt * 100), 15, "0")
					+ StringUtils.leftPad(String.valueOf(iTotalCnt + 2), 9, "0")
					+ StringUtils.leftPad(String.valueOf(iHashTot % 10000), 4, "0") + StringUtils.rightPad("", 64, " ");

		out.write(fText);
		out.newLine();
		out.flush();
	}
	
	
}
