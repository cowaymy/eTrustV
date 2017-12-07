package com.coway.trust.web.common.claim;

import java.io.IOException;
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

	private String sSecCode;
	private String sText;

	private long iTotalAmt = 0;
	private long sLimit = 0;
	private long ihashtot3 = 0;
	private String sbatchNo;

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

		String inputDate = CommonUtils.nvl(params.get("ctrlBatchDt")).equals("") ? "1900-01-01"
				: (String) params.get("ctrlBatchDt");

		sbatchNo = CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "ddMMyy") + "01";

		sSecCode = StringUtils.leftPad(String.valueOf((Integer.parseInt(sbatchNo) + 1208083646)), 10, " ");
		sText = "01" + CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "ddMMyy") + "01" + "2120"
				+ StringUtils.rightPad("WOONGJIN COWAY", 40, " ")
				+ CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "ddMMyy") + sSecCode
				+ StringUtils.rightPad("", 128, " ");

		out.write(sText);
		out.newLine();
		out.flush();

		LOGGER.debug("write Header complete.....");
	}

	private void writeBody(ResultContext<? extends Map<String, Object>> result) throws IOException {
		Map<String, Object> dataRow = result.getResultObject();

		// body
		String stextDetails;
		String sDocno;
		String sNRIC;
		String sDrName;
		String sDrAccNo;
		String sItemID;
		String sReservedA;
		String sReservedB;
		String sUnusedA;
		// String sUnusedB;

		sDocno = StringUtils.rightPad(String.valueOf(dataRow.get("cntrctNOrdNo")), 30, " ");
		sItemID = StringUtils.rightPad(String.valueOf(dataRow.get("bankDtlId")), 56, " ");
		sReservedA = StringUtils.rightPad("", 11, " ");
		sReservedB = StringUtils.rightPad("", 2, " ");
		sUnusedA = StringUtils.rightPad("", 8, " ");

		// 암호화는 나중에 처리
		// sDrAccNo = EncryptionProvider.Decrypt(det.AccNo).Trim().PadRight(14, ' ');
		sDrAccNo = StringUtils.rightPad("34204542899", 14, " ");

		sDrName = ((String) dataRow.get("bankDtlDrName")).length() > 40
				? ((String) dataRow.get("bankDtlDrName")).trim().substring(0, 40)
				: StringUtils.rightPad((String) dataRow.get("bankDtlDrName"), 40, " ");

		sNRIC = ((String) dataRow.get("bankDtlDrNric")).length() > 16
				? ((String) dataRow.get("bankDtlDrNric")).trim().substring(0, 16)
				: StringUtils.rightPad((String) dataRow.get("bankDtlDrNric"), 16, " ");

		sLimit = ((java.math.BigDecimal) dataRow.get("bankDtlAmt")).longValue() * 100;
		iTotalAmt = iTotalAmt + sLimit;
		ihashtot3 = ihashtot3 + sLimit + Long.parseLong(sDrAccNo.trim());

		String debitAmount = StringUtils.leftPad(String.valueOf(sLimit), 13, "0");
		// sUnusedB = StringUtils.rightPad("", 25, " ");

		stextDetails = "02" + sbatchNo + sDocno + sNRIC + sDrName + sDrAccNo + debitAmount + sReservedA + sReservedB
				+ sUnusedA + sItemID;

		out.write(stextDetails);
		out.newLine();
		out.flush();

		totalCount++;

		sLimit = ((java.math.BigDecimal) dataRow.get("bankDtlAmt")).longValue() * 100;
		sDrAccNo = StringUtils.rightPad("34204542899", 14, " ");
		iTotalAmt = iTotalAmt + sLimit;
		ihashtot3 = ihashtot3 + sLimit + Long.parseLong(sDrAccNo.trim());
	}

	public void writeFooter() throws IOException {
		String sRecTot = StringUtils.leftPad(String.valueOf(totalCount), 6, "0");
		String sBatchTot = StringUtils.leftPad(String.valueOf(iTotalAmt), 15, "0");
		String sHashTot = String.valueOf(ihashtot3);

		int endIndex = sHashTot.length() > 15 ? 15 : sHashTot.length();

		String footer = "03" + sbatchNo + sRecTot + sBatchTot + StringUtils.rightPad("", 42, " ")
				+ sHashTot.substring(0, endIndex) + StringUtils.rightPad("", 112, " ");

		out.write(footer);
		out.newLine();
		out.flush();
	}
}
