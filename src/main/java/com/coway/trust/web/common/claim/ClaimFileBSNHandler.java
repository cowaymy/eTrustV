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
	String todayDate = "";
	String sorgacc = "";
	String inputDate = "";

	// 본문 작성을 위한 변수
	int counter = 1;
	long iHashTot = 0;
	String stextDetails = "";
	String sLimit = "";
	String sDrAccNo = "";
	String sDocno = "";
	String sNRIC = "";
	String sMNric = "";
	long iTotalAmt = 0;
	int iTotalCnt = 0;

	BigDecimal amount = null;
	BigDecimal hunred = new BigDecimal(100);

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
		try {
    		sorigid = "M4743600";
    		todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "yyyy-MM-dd");
    		inputDate = CommonUtils.nvl(params.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String) params.get("ctrlBatchDt");
    		//senrdate = CommonUtils.getNowDate();;
    		sorgacc = "1410029000510851";
    		//sText = sorigid + CommonUtils.changeFormat(CommonUtils.getAddDay(todayDate, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyyMMdd") + "29755" + "0000000" + sorgacc + StringUtils.leftPad("", 76, " ");
    		sText = sorigid + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "yyyyMMdd") + "29755" + "0000000" + sorgacc + StringUtils.leftPad("", 76, " ");
    		out.write(sText);
    		out.newLine();
    		out.flush();

    		LOGGER.debug("write Header complete.....");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private void writeBody(ResultContext<? extends Map<String, Object>> result) throws IOException {
		Map<String, Object> dataRow = result.getResultObject();

		// 본문 작성
		try {

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

    		//금액 계산
    		amount = (BigDecimal)dataRow.get("bankDtlAmt");
    		sLimit = StringUtils.leftPad(String.valueOf(amount.multiply(hunred).longValue()), 15, "0");

    		//sLimit = StringUtils.leftPad(String.valueOf(((java.math.BigDecimal) dataRow.get("bankDtlAmt")).longValue() * 100), 15, "0");
    		iTotalAmt = iTotalAmt + amount.multiply(hunred).longValue();



    		if ((String.valueOf(dataRow.get("bankDtlDrNric"))).trim().length() == 12) {
    			//CommonUtils.changeFormat(CommonUtils.getAddDay(todayDate, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyyMMdd")
    			stextDetails = sorigid + CommonUtils.changeFormat(String.valueOf(dataRow.get("bankDtlDrDt")), "yyyy-MM-dd", "yyyyMMdd") + "29755" + StringUtils.leftPad(String.valueOf(counter), 7, "0")
				+ sLimit + sDrAccNo + "A100" + StringUtils.rightPad("", 4, " ") + sDocno
				+ StringUtils.rightPad("", 12, " ") + sNRIC + StringUtils.rightPad("", 8, " ") + " ";
    		} else {
    			//CommonUtils.changeFormat(CommonUtils.getAddDay(todayDate, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyyMMdd")
    			stextDetails = sorigid + CommonUtils.changeFormat(String.valueOf(dataRow.get("bankDtlDrDt")), "yyyy-MM-dd", "yyyyMMdd") + "29755" + StringUtils.leftPad(String.valueOf(counter), 7, "0")
				+ sLimit + sDrAccNo + "A100" + StringUtils.rightPad("", 4, " ") + sDocno
				+ StringUtils.rightPad("", 12, " ") + StringUtils.rightPad("", 12, " ") + sMNric + " ";
    		}

    		iHashTot = iHashTot + Long.parseLong(CommonUtils.right(sDrAccNo.trim(), 4));

    		out.write(stextDetails);
    		out.newLine();
    		out.flush();

    		counter = counter + 1;
    		iTotalCnt++;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void writeFooter() throws IOException {
		try {
    		fText = sorigid +
    				//CommonUtils.changeFormat(CommonUtils.getAddDay(todayDate, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyyMMdd")
    				CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "yyyyMMdd")
    					+ "29755" + "9999999" + StringUtils.leftPad(String.valueOf(iTotalAmt), 15, "0")
    					+ StringUtils.leftPad(String.valueOf(iTotalCnt + 2), 9, "0")
    					+ StringUtils.leftPad(String.valueOf(iHashTot % 10000), 4, "0") + StringUtils.rightPad("", 64, " ");

    		out.write(fText);
    		out.newLine();
    		out.flush();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}


}
