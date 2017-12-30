package com.coway.trust.web.common.claim;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.session.ResultContext;
import org.apache.ibatis.session.ResultHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

public class ClaimFileNewALBHandler extends BasicTextDownloadHandler implements ResultHandler<Map<String, Object>> {
	private static final Logger LOGGER = LoggerFactory.getLogger(ClaimFileNewALBHandler.class);
	
	// 본문 작성을 위한 변수
	private String dRecordType = "D";
	private String dDebtiAccNo = "";
	private String dDebitAccName = "";
	private String dBankCode = "MFBBMYKL";
	private String dCollAmt = "";
	private String dOrderNo = "";
	private String dSellerInternalRefNo = "";
	private String dBuyerNewICNo = "";
	private String dBuyerOldICNo = "";
	private String dBuyerBusinessRegNo = "";
	private String dBuyerOtherIDValue = "";
	private String dNotiReq = "N";
	private String mobNo = "";
	private String email1 = "";
	private String email2 = "";
	private String accNo = "";
	private String accNRIC = "";
	
	//footer를 위한 변수
	private long hashTotal = 0;
	//private double totalCollection = 0.0D;
	private BigDecimal totalCollection = new BigDecimal(0); 
	private int totalCount = 0;
	

	public ClaimFileNewALBHandler(FileInfoVO fileInfoVO, Map<String, Object> params) {
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
		String inputDate = CommonUtils.nvl(params.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String) params.get("ctrlBatchDt");
		
		String hRecordType = "H";
		String hCreditAccNo = "140550010179955";
		String hCompanyName = "Coway (M) Sdn Bhd";
		String hFileBatchRefNo = String.valueOf(params.get("ctrlId"));
		String hCollectionDate = CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "ddMMyyyy");
		String hSellerID = "AD10000101";
		String hCreditType = "S";

		String headerStr = hRecordType + "|" + hCreditAccNo + "|" + hCompanyName + "|" + hFileBatchRefNo + "|"
				+ hCollectionDate + "|" + hSellerID + "|" + hCreditType + "|";

		out.write(headerStr);
		out.newLine();
		out.flush();
		
		LOGGER.debug("write Header complete.....");
	}

	private void writeBody(ResultContext<? extends Map<String, Object>> result) throws IOException {
		Map<String, Object> dataRow = result.getResultObject();
		
		// 본문 작성
		// ISSUE : 암호화 RULE 규정
		// string AccNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).ToString().Trim();
		accNo = String.valueOf(dataRow.get("bankDtlDrAccNo")).trim();
		accNRIC = ((String) dataRow.get("bankDtlDrNric")).trim();
		dDebtiAccNo = accNo.length() > 17 ? accNo.substring(0, 17) : accNo;
		dDebitAccName = ((String) dataRow.get("bankDtlDrName")).length() > 40 ? 
									((String) dataRow.get("bankDtlDrName")).substring(0, 40) : (String) dataRow.get("bankDtlDrName");
		
									
		dCollAmt = CommonUtils.getNumberFormat(String.valueOf(dataRow.get("bankDtlAmt")), "0.00");
		
		
		dOrderNo = (String) dataRow.get("cntrctNOrdNo");
		dSellerInternalRefNo = String.valueOf(dataRow.get("bankDtlId")).length() > 40 ? 
							(String.valueOf(dataRow.get("bankDtlId"))).substring(0, 40) : String.valueOf(dataRow.get("bankDtlId"));
							
		if (accNRIC.length() == 12) {
			dBuyerNewICNo = accNRIC;
		} else if (accNRIC.length() == 8) {
			dBuyerOldICNo = accNRIC;
		} else {
			dBuyerBusinessRegNo = accNRIC;
		}

		String detailStr = dRecordType + "|" + dDebtiAccNo + "|" + dDebitAccName + "|" + dBankCode + "|"
				+ dCollAmt + "|" + dOrderNo + "|" + dSellerInternalRefNo + "|" + dBuyerNewICNo + "|"
				+ dBuyerOldICNo + "|" + dBuyerBusinessRegNo + "|" + dBuyerOtherIDValue + "|" + dNotiReq + "|"
				+ mobNo + "|" + email1 + "|" + email2 + "|";

		
		out.write(detailStr);
		out.newLine();
		out.flush();
		
		//totalCollection += ((java.math.BigDecimal) dataRow.get("bankDtlAmt")).doubleValue();
		totalCollection = totalCollection.add((java.math.BigDecimal) dataRow.get("bankDtlAmt"));
		
		hashTotal += Long.parseLong(CommonUtils.right(dDebtiAccNo, 10));
		totalCount ++;
			
	}

	public void writeFooter() throws IOException {
		String tRecordType = "T";
		String tTotalRecord = String.valueOf(totalCount);
		String tTotalCollectionAmt = CommonUtils.getNumberFormat(String.valueOf(totalCollection), "0.00");
		String tmpHashTotal = (CommonUtils.getNumberFormat(hashTotal, "0000000000"));
		String tHashTotal = CommonUtils.right(tmpHashTotal, 10);

		String trailerStr = "";
		trailerStr = tRecordType + "|" + tTotalRecord + "|" + tTotalCollectionAmt + "|" + tHashTotal + "|";

		out.write(trailerStr);
		out.newLine();
		out.flush();
	}
}
