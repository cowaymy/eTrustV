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

public class ClaimFilePBBHandler extends BasicTextDownloadHandler implements ResultHandler<Map<String, Object>> {
	private static final Logger LOGGER = LoggerFactory.getLogger(ClaimFilePBBHandler.class);

	// 헤더 작성을 위한 변수
	String inputDate = "";
	String sText = "";

	// 본문 작성을 위한 변수
	String stextDetails = "";
	String sDocno = "";
	String tmpSDrName = "";
	String sDrAccNo = "";
	String sDrName = "";
	String sNRIC = "";
	String sLimit = "";
	String sAmt = "";
	long iTotalAmt = 0;
	String sFiller = "";
	String sHashEntry = "";
	long iHashTot = 0;

	BigDecimal amount = null;
	BigDecimal hunred = new BigDecimal(100);

	String trimAccNo = "";
	int startIdx = 0;
	int iTotalCnt = 0;

	// footer 작성을 위한 변수
	String sTextBtn = "";

	public ClaimFilePBBHandler(FileInfoVO fileInfoVO, Map<String, Object> params) {
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
		//3139835308 Old Account
		//3999527828 New Account
		sText = "FH0001" + "3999527828" + StringUtils.rightPad("PBB", 10, " ")
				+ CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "yyyyMMdd")
				+ StringUtils.rightPad("WCBDEBIT", 20, " ")
				+ CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "yyyyMMdd") + StringUtils.rightPad("", 138, " ");

		out.write(sText);
		out.newLine();
		out.flush();

		LOGGER.debug("write Header complete.....");
	}

	private void writeBody(ResultContext<? extends Map<String, Object>> result) throws IOException {
		Map<String, Object> dataRow = result.getResultObject();

		// 본문 작성
		sDocno = StringUtils.rightPad((String.valueOf(dataRow.get("cntrctNOrdNo"))).trim(), 20, " ");
		// ISSUE : 암호화 RULE 규정
		// sDrAccNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).Trim().PadRight(20,' ');
		sDrAccNo = StringUtils.rightPad(String.valueOf(dataRow.get("bankDtlDrAccNo")).trim(), 20, " ");

		tmpSDrName = (String.valueOf(dataRow.get("bankDtlDrName"))).trim(); sDrName = tmpSDrName.length() > 40
								? tmpSDrName.substring(0, 40) : StringUtils.rightPad(tmpSDrName, 40, " ");
		sNRIC = StringUtils.rightPad(String.valueOf(dataRow.get("bankDtlDrNric")), 20, " ");

		//금액 계산
		amount = (BigDecimal)dataRow.get("bankDtlAmt");
		sLimit = StringUtils.leftPad(String.valueOf(amount.multiply(hunred).longValue()), 12, "0");
		sAmt = StringUtils.leftPad(sLimit, 16, "0");

		//iTotalAmt = iTotalAmt + Double.parseDouble(sLimit);
		iTotalAmt = iTotalAmt + amount.multiply(hunred).longValue();

		sFiller = StringUtils.rightPad("", 87, " ");

		// substring을 위한 세팅 시작
		trimAccNo = sDrAccNo.trim();
		startIdx = trimAccNo.length() - 4 < 1 ? 0 : trimAccNo.length() - 4;
		// substring을 위한 세팅 종료

		sHashEntry = String.valueOf((Integer.parseInt(sLimit) + Integer.parseInt(trimAccNo.substring(startIdx, trimAccNo.length()))));
		sHashEntry = StringUtils.leftPad(sHashEntry, 15, "0");
		stextDetails = "DT" + sDrAccNo + sAmt + sDrName + sDocno + sHashEntry + sFiller;
		iHashTot = iHashTot + Integer.parseInt(trimAccNo.substring(startIdx, trimAccNo.length()));
		iTotalCnt++;

		out.write(stextDetails);
		out.newLine();
		out.flush();

	}

	public void writeFooter() throws IOException {
		//3139835308 Old Account
		//3999527828 New Account
		sTextBtn = "FT0001" + "3999527828" + StringUtils.rightPad("PBB", 10, " ")
				+ StringUtils.leftPad(String.valueOf((iTotalCnt + 2)), 10, "0")
				+ StringUtils.leftPad(String.valueOf(iTotalAmt), 20, "0")
				+ StringUtils.leftPad(String.valueOf(iHashTot), 15, "0") + StringUtils.rightPad("", 129, " ");

		out.write(sTextBtn);
		out.newLine();
		out.flush();
	}
}
