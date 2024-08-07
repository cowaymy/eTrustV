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

public class ClaimFileMyClearHandler extends BasicTextDownloadHandler implements ResultHandler<Map<String, Object>> {
	private static final Logger LOGGER = LoggerFactory.getLogger(ClaimFileMyClearHandler.class);	
	
	// 헤더 작성을 위한 변수
	String strHeader = "";
	String strHeaderCountryCode = "";
	String strHeaderBranchCode = "";
	String strHeaderBranchDivision = "";
	String strHeaderAccount = "";
	String strHeaderUnusedrSpaces = "";
	
	// 본문 작성을 위한 변수
	String strRecordType = "";
	String strRecordTransactionType = "";
	String strRecordRefNo = "";
	String strRecordAccNo = "";
	String strRecordBankCode = "";
	String strRecordBranch = "";
	String strRecordPayerName = "";
	String strRecordPayerCode = "";
	String strRecordBillAmt = "";
	String strRecordBillDate = "";
	String strRecordPayerEmail = "";
	String strRecordPayerPhone = "";
	String strRecordPayerFax = "";
	String strRecordPaymentRef1 = "";
	String strRecordPaymentRef2 = "";
	String strRecordPaymentRef3 = "";
	String strRecordUnusedSpaces = "";
	String strRecord = "";
	//double iTotalAmt = 0.0D;
	private BigDecimal iTotalAmt = new BigDecimal(0);
	int iTotalCnt = 0;	
	
	// footer 작성을 위한 변수
	String strTrailer = "";
	String strTrailerTotalRecord = "";
	String strTrailerUnusedSpaces = "";
	String strTrailerTotalAmount = "";
	String strTrailerUnusedSpaces2 = "";

	public ClaimFileMyClearHandler(FileInfoVO fileInfoVO, Map<String, Object> params) {
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
		strHeader = "";
		strHeaderCountryCode = "MY";
		strHeaderBranchCode = StringUtils.rightPad("950", 5, " ");
		//strHeaderBranchDivision = StringUtils.rightPad(String.valueOf(params.get("ctrlId")), 10, " ");
		strHeaderBranchDivision = StringUtils.rightPad("0", 10, " ");
		strHeaderAccount = StringUtils.rightPad("117192008", 30, " ");
		strHeaderUnusedrSpaces = StringUtils.rightPad("", 30, " ");

		strHeader = strHeaderCountryCode + strHeaderBranchCode + strHeaderBranchDivision + strHeaderAccount
				+ strHeaderUnusedrSpaces;

		out.write(strHeader);
		out.newLine();
		out.flush();
				
		LOGGER.debug("write Header complete.....");
	}

	private void writeBody(ResultContext<? extends Map<String, Object>> result) throws IOException {
		Map<String, Object> dataRow = result.getResultObject();
		
		// 본문 작성
		strRecordType = "DDI";
		strRecordTransactionType = StringUtils.rightPad("87", 4, " ");
		strRecordRefNo = StringUtils.rightPad(String.valueOf(dataRow.get("cntrctNOrdNo")), 20, " ");

		// ISSUE : 암호화 RULE 규정
		// String strRecordAccNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).PadRight(30, ' ');
		strRecordAccNo = StringUtils.rightPad(String.valueOf(dataRow.get("bankDtlDrAccNo")).trim(), 30, " ");
		strRecordBankCode = StringUtils.rightPad((String.valueOf(dataRow.get("bic"))).trim(), 16, " ");
		strRecordBranch = StringUtils.rightPad("", 5, " ");
		strRecordPayerName = (String.valueOf(dataRow.get("bankDtlDrName"))).trim().length() > 70 ? 
					(String.valueOf(dataRow.get("bankDtlDrName"))).trim().substring(0, 70) : StringUtils.rightPad((String.valueOf(dataRow.get("bankDtlDrName"))).trim(), 70, " ");
		strRecordPayerCode = (String.valueOf(dataRow.get("bankDtlDrNric"))).trim().length() > 20 ? 
					(String.valueOf(dataRow.get("bankDtlDrNric"))).trim().substring(0, 20) : StringUtils.rightPad((String.valueOf(dataRow.get("bankDtlDrNric"))).trim(), 20, " ");
		
					strRecordBillAmt = StringUtils.leftPad(CommonUtils.getNumberFormat(String.valueOf(dataRow.get("bankDtlAmt")), "0.00"), 16, "0");
		
		strRecordBillDate = CommonUtils.changeFormat(String.valueOf(dataRow.get("bankDtlDrDt")),"yyyy-MM-dd", "ddMMyyyy");
		strRecordPayerEmail = StringUtils.rightPad("", 50, " ");
		strRecordPayerPhone = StringUtils.rightPad("", 15, " ");
		strRecordPayerFax = StringUtils.rightPad("", 15, " ");
		strRecordPaymentRef1 = StringUtils.rightPad("", 35, " ");
		strRecordPaymentRef2 = StringUtils.rightPad("", 140, " ");
		strRecordPaymentRef3 = StringUtils.rightPad("", 140, " ");
		strRecordUnusedSpaces = StringUtils.rightPad("", 30, " ");

		strRecord = strRecordType + strRecordTransactionType + strRecordRefNo + strRecordAccNo
				+ strRecordBankCode + strRecordBranch + strRecordPayerName + strRecordPayerCode
				+ strRecordBillAmt + strRecordBillDate + strRecordPayerEmail + strRecordPayerPhone
				+ strRecordPayerFax + strRecordPaymentRef1 + strRecordPaymentRef2 + strRecordPaymentRef3
				+ strRecordUnusedSpaces;

		//iTotalAmt = iTotalAmt + ((java.math.BigDecimal) dataRow.get("bankDtlAmt")).doubleValue();		
		iTotalAmt = iTotalAmt.add((java.math.BigDecimal) dataRow.get("bankDtlAmt"));
		
		iTotalCnt++;

		out.write(strRecord);
		out.newLine();
		out.flush();
	}

	public void writeFooter() throws IOException {		

		strTrailerTotalRecord = StringUtils.leftPad(String.valueOf(iTotalCnt), 8, "0");
		strTrailerUnusedSpaces = StringUtils.rightPad("0", 8, "0");
		strTrailerTotalAmount = StringUtils.leftPad(CommonUtils.getNumberFormat(String.valueOf(iTotalAmt), "0.00"), 16, "0");
		strTrailerUnusedSpaces2 = StringUtils.rightPad("", 30, " ");

		strTrailer = strTrailerTotalRecord + strTrailerUnusedSpaces + strTrailerTotalAmount + strTrailerUnusedSpaces2;

		out.write(strTrailer);
		out.newLine();
		out.flush();
	}
	
	
}
