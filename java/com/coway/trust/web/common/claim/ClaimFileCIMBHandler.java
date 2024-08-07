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

public class ClaimFileCIMBHandler extends BasicTextDownloadHandler implements ResultHandler<Map<String, Object>> {
	private static final Logger LOGGER = LoggerFactory.getLogger(ClaimFileCIMBHandler.class);

	// 헤더 작성
	String inputDate = "";
	String sbatchNo = "";
	String sSecCode = "";
	String sText = "";

	// 본문 작성
	String stextDetails = "";
	String sDocno = "";
	String sNRIC = "";
	String sDrName = "";
	String sDrAccNo = "";
	String sItemID = "";
	String sReservedA = "";
	String sReservedB = "";
	String sUnusedA = "";
	String debitAmount = "";
	String sOrgCode = "";

	long sLimit = 0;
	long iTotalAmt = 0;
	long ihashtot3 = 0;
	int iTotalCnt = 0;

	// footer 작성
	String sRecTot = "";
	String sBatchTot = "";
	String sHashTot = "";
	int endIndex = 0;
	String sTextBtn = "";

	BigDecimal amount = null;
	BigDecimal hunred = new BigDecimal(100);

	public ClaimFileCIMBHandler(FileInfoVO fileInfoVO, Map<String, Object> params) {
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
		sbatchNo = CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "ddMMyy") + "01";
		sSecCode = StringUtils.leftPad(String.valueOf((Integer.parseInt(sbatchNo) + 1208083646)), 10, " ");

		//20210412 YONGJH: substring operation is based on batchName value i.e. "BILLING_ORG2120_"
		sOrgCode = ((String) params.get("batchName")).substring(11, 15);

		sText = "01" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "ddMMyy") + "01" + sOrgCode
				+ StringUtils.rightPad("WOONGJIN COWAY", 40, " ")
				+ CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "ddMMyyyy") + sSecCode
				+ StringUtils.rightPad("", 128, " ");

		out.write(sText);
		out.newLine();
		out.flush();

		LOGGER.debug("write Header complete.....");
	}

	private void writeBody(ResultContext<? extends Map<String, Object>> result) throws IOException {
		Map<String, Object> dataRow = result.getResultObject();

		sDocno = StringUtils.rightPad(String.valueOf(dataRow.get("cntrctNOrdNo")), 30, " ");
		sItemID = StringUtils.rightPad(String.valueOf(dataRow.get("bankDtlId")), 56, " ");
		sReservedA = StringUtils.rightPad("", 11, " ");
		sReservedB = StringUtils.rightPad("", 2, " ");
		sUnusedA = StringUtils.rightPad("", 8, " ");

		// ISSUE : 암호화 RULE 규정
		// sDrAccNo = EncryptionProvider.Decrypt(det.AccNo).Trim().PadRight(14, ' ');
		sDrAccNo = StringUtils.rightPad(String.valueOf(dataRow.get("bankDtlDrAccNo")) , 14, " ");

		sDrName = ((String) dataRow.get("bankDtlDrName")).length() > 40
				? ((String) dataRow.get("bankDtlDrName")).trim().substring(0, 40)
				: StringUtils.rightPad((String) dataRow.get("bankDtlDrName"), 40, " ");

		sNRIC = ((String) dataRow.get("bankDtlDrNric")).length() > 16
				? ((String) dataRow.get("bankDtlDrNric")).trim().substring(0, 16)
				: StringUtils.rightPad((String) dataRow.get("bankDtlDrNric"), 16, " ");

		//sLimit = ((java.math.BigDecimal) dataRow.get("bankDtlAmt")).longValue() * 100;

		//금액 계산
		amount = (BigDecimal)dataRow.get("bankDtlAmt");
		sLimit = amount.multiply(hunred).longValue();


		iTotalAmt = iTotalAmt + sLimit;
		ihashtot3 = ihashtot3 + sLimit + Long.parseLong(sDrAccNo.trim());
		iTotalCnt++;

		debitAmount = StringUtils.leftPad(String.valueOf(sLimit), 13, "0");


		stextDetails = "02" + sbatchNo + sDocno + sNRIC + sDrName + sDrAccNo + debitAmount + sReservedA
				+ sReservedB + sUnusedA + sItemID;

		out.write(stextDetails);
		out.newLine();
		out.flush();



	}

	public void writeFooter() throws IOException {
		sRecTot = StringUtils.leftPad(String.valueOf(iTotalCnt), 6, "0");
		sBatchTot = StringUtils.leftPad(String.valueOf(iTotalAmt), 15, "0");
		sHashTot = String.valueOf(ihashtot3);

		endIndex = sHashTot.length() > 15 ? 15 : sHashTot.length();

		sTextBtn = "03" + sbatchNo + sRecTot + sBatchTot + StringUtils.rightPad("", 42, " ")
				+ sHashTot.substring(0, endIndex) + StringUtils.rightPad("", 112, " ");

		out.write(sTextBtn);
		out.newLine();
		out.flush();

	}
}
