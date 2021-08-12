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

public class ClaimFileRHBHandler extends BasicTextDownloadHandler implements ResultHandler<Map<String, Object>> {
	private static final Logger LOGGER = LoggerFactory.getLogger(ClaimFileRHBHandler.class);	
	
	private long intamtinh = 0;
	private long intaccinh = 0;
	
	// 헤더 작성을 위한 변수
	String sText = "";
	String inputDate = "";
	String todayDate = "";
	
	// 본문 작성을 위한 변수
	String stextDetails = "";
	String sDrAccNo = "";
	String sDrName = "";
	String sLimit = "";
	String sDocno = "";
	long iHashTot = 0;
	long iTotalAmt = 0;
	int iTotalCnt = 0;
	
	BigDecimal amount = null;
	BigDecimal hunred = new BigDecimal(100);
	
	// footer 작성을 위한 변수
	String sTextBtn = "";
	

	public ClaimFileRHBHandler(FileInfoVO fileInfoVO, Map<String, Object> params) {
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
		try {
			// 헤더 작성
			todayDate = CommonUtils.changeFormat(CommonUtils.getNowDate(), "yyyyMMdd", "yyyy-MM-dd");
			inputDate = CommonUtils.nvl(params.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String) params.get("ctrlBatchDt");
			
			sText = CommonUtils.changeFormat(CommonUtils.getAddDay(todayDate, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "ddMMyyyy") + "00035" + "400" + "001" + "0"
					+ "21401360018413" + StringUtils.rightPad("", 16, " ") + StringUtils.rightPad("Coway (M) Sdn Bhd", 35, " ")
					+ StringUtils.rightPad("735420-H", 12, " ") + StringUtils.rightPad("", 303, " ");
			
			out.write(sText);
			out.newLine();
			out.flush();
					
			LOGGER.debug("write Header complete.....");
			
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		
	}

	private void writeBody(ResultContext<? extends Map<String, Object>> result) throws IOException {
		Map<String, Object> dataRow = result.getResultObject();
		
		try {
			// 본문 작성
			// ISSUE : 암호화 RULE 규정
			// sDrAccNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).PadLeft(14,' ');
			sDrAccNo = StringUtils.leftPad(String.valueOf(dataRow.get("bankDtlDrAccNo")) , 14, " ");
		
			sDrName = (String.valueOf(dataRow.get("bankDtlDrName"))).trim().length() > 35 ? 
							(String.valueOf(dataRow.get("bankDtlDrName"))).trim().substring(0, 35) : StringUtils.rightPad((String.valueOf(dataRow.get("bankDtlDrName"))).trim(), 35, " ");
		
    		//sLimit = StringUtils.leftPad(String.valueOf(((java.math.BigDecimal) dataRow.get("bankDtlAmt")).longValue() * 100), 15, "0");
    		//금액 계산
    		amount = (BigDecimal)dataRow.get("bankDtlAmt");		
    		sLimit = StringUtils.leftPad(String.valueOf(amount.multiply(hunred).longValue()), 15, "0");
    		
    		sDocno = StringUtils.rightPad((String.valueOf(dataRow.get("cntrctNOrdNo"))).trim(), 20, " ");
    		iHashTot = this.CalculateCheckSum_RHB( amount.multiply(hunred).longValue()      ,sDrAccNo.trim(), iHashTot);
    		//iTotalAmt = iTotalAmt + Double.parseDouble(sLimit.trim());
    		iTotalAmt = iTotalAmt + amount.multiply(hunred).longValue(); 
    		
    		stextDetails = CommonUtils.changeFormat(CommonUtils.getAddDay(todayDate, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "ddMMyyyy") + "00035" + "400" + "001"
    								+ "1" + sDrAccNo + StringUtils.rightPad("", 16, " ") + sDrName
    								+ StringUtils.rightPad("", 12, " ") + sLimit + sDocno + StringUtils.rightPad("", 10, " ")
    								+ StringUtils.rightPad("0", 15, " ") + StringUtils.rightPad("0", 15, " ")
    								+ StringUtils.rightPad("", 7, " ") + StringUtils.rightPad("0", 15, " ")
    								+ StringUtils.rightPad("", 16, " ") + intamtinh + StringUtils.rightPad("", 5, " ") + intaccinh
    								+ StringUtils.rightPad("", 190, " ");
    		
    		iTotalCnt++;
    		
    		out.write(stextDetails);
    		out.newLine();
    		out.flush();
    		
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
					
			
	}

	public void writeFooter() throws IOException {
		try{
    		// footer 작성
    		sTextBtn = CommonUtils.changeFormat(CommonUtils.getAddDay(todayDate, 1, "yyyy-MM-dd"), "yyyy-MM-dd", "ddMMyyyy") + "00035" + "400" + "001" + "9"
    				+ "21401360018413" + StringUtils.rightPad("", 16, " ")
    				+ StringUtils.leftPad(String.valueOf(iTotalAmt), 15, "0")
    				+ StringUtils.leftPad(String.valueOf(iTotalCnt), 12, "0")
    				+ StringUtils.leftPad(String.valueOf(iHashTot), 16, "0") + StringUtils.rightPad("0", 15, "0")
    				+ StringUtils.rightPad("", 292, " ");
    
    		out.write(sTextBtn);
    		out.newLine();
    		out.flush();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	/**
	 * 
	 * @param amt
	 * @param accNo
	 * @param iHashTot
	 * @return
	 */
	private long CalculateCheckSum_RHB(long amt, String accNo, long iHashTot) {
		long iAmt64 = 0;
		long iAcc64 = 0;

		//iAmt64 = Long.parseLong(String.valueOf(amt * 100));
		iAmt64 = amt;
		iAcc64 = accNo.length() > 8 ? Long.parseLong(CommonUtils.right(accNo, 8)) : Long.parseLong(accNo.trim());

		intamtinh = iAmt64;
		intaccinh = iAcc64;

		return (iAmt64 * iAcc64) + iHashTot;
	}
}
