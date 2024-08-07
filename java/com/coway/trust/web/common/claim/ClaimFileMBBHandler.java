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

public class ClaimFileMBBHandler extends BasicTextDownloadHandler implements ResultHandler<Map<String, Object>> {
	private static final Logger LOGGER = LoggerFactory.getLogger(ClaimFileMBBHandler.class);

	// 헤더 작성을 위한 변수
	String inputDate = "";
	String strHeader = "";
	String strHeaderFix1 = "";
	String strHeaderFix2 = "";
	String strHeaderOriginatorName = "";

	String strHeaderBillDate = "";
	String strHeaderOriginatorID = "";
	String strHeaderBankUse = "";

	// 본문 작성을 위한 변수
	String strRecord = "";
	String strRecordFix = "";
	String strRecordAcc = "";
	String strRecordBillAmt = "";
	String tmpStrRecordNRIC = "";
	String strRecordNRIC = "";
	String strRecordBankUse1 = "";
	String strRecordBillNo = "";
	String strRecordBankUse2 = "";
	String tmpStrRecordPayer = "";
	String strRecordPayerName = "";
	String strRecordBankUse3 = "";

	long iHashTot = 0;
	long iTotalAmt = 0;
	int iTotalCnt = 0;

	// footer 작성을 위한 변수
	String strTrailer = "";
	String strTrailerFix = "";
	String strTrailerTotalRecord = "";
	String strTrailerTotalAmount = "";
	String strTrailerTotalHash = "";
	String strTrailerBankUse = "";

	BigDecimal amount = null;
	BigDecimal hunred = new BigDecimal(100);


	public ClaimFileMBBHandler(FileInfoVO fileInfoVO, Map<String, Object> params) {
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

		strHeader = "";
		strHeaderFix1 = "VOL1";
		strHeaderFix2 = "NN";
		strHeaderOriginatorName = StringUtils.rightPad("WOONGJINCOWAY", 13, " ");

		strHeaderBillDate = CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "ddMMyy");
		strHeaderOriginatorID = "02172";
		strHeaderBankUse = StringUtils.rightPad("", 47, " ");

		strHeader = strHeaderFix1 + strHeaderFix2 + strHeaderOriginatorName + strHeaderBillDate + strHeaderOriginatorID
				+ strHeaderBankUse;

		out.write(strHeader);
		out.newLine();
		out.flush();

		LOGGER.debug("write Header complete.....");
	}

	private void writeBody(ResultContext<? extends Map<String, Object>> result) throws IOException {
		Map<String, Object> dataRow = result.getResultObject();

		strRecord = "";
		strRecordFix = "00";

		// 암호화는 나중에 하자
		// String strRecord_Acc = EncryptionProvider.Decrypt(det.AccNo.Trim()).PadLeft(12, '0');
		strRecordAcc = StringUtils.leftPad(String.valueOf(dataRow.get("bankDtlDrAccNo")) , 12, "0");

		//금액 계산
		amount = (BigDecimal)dataRow.get("bankDtlAmt");
		//strRecordBillAmt = StringUtils.leftPad(String.valueOf(((java.math.BigDecimal) dataRow.get("bankDtlAmt")).longValue() * 100), 12, "0");
		strRecordBillAmt = StringUtils.leftPad(String.valueOf(amount.multiply(hunred).longValue()), 12, "0");

		tmpStrRecordNRIC = (String.valueOf(dataRow.get("bankDtlDrNric"))).trim();
		strRecordNRIC = tmpStrRecordNRIC.length() > 8 ? CommonUtils.right(tmpStrRecordNRIC, 8) : StringUtils.leftPad(tmpStrRecordNRIC, 8, " ");
		strRecordBankUse1 = StringUtils.leftPad("", 1, " ");
		strRecordBillNo = StringUtils.rightPad(String.valueOf(dataRow.get("cntrctNOrdNo")), 14, " ");
		strRecordBankUse2 = StringUtils.leftPad("", 1, " ");

		tmpStrRecordPayer = (String.valueOf(dataRow.get("bankDtlDrName"))).trim();
		strRecordPayerName = tmpStrRecordPayer.length() > 20 ? tmpStrRecordPayer.substring(0, 20) : StringUtils.rightPad(tmpStrRecordPayer, 20, " ");
		strRecordBankUse3 = StringUtils.leftPad("", 1, " ");

		strRecord = strRecordFix + strRecordAcc + strRecordBillAmt + strRecordNRIC + strRecordBankUse1
				+ strRecordBillNo + strRecordBankUse2 + strRecordPayerName + strRecordBankUse3;


		iHashTot = iHashTot + Long.parseLong(CommonUtils.right(String.valueOf(dataRow.get("bankDtlDrAccNo")).trim(), 4));
		iTotalAmt = iTotalAmt + amount.multiply(hunred).longValue();
		iTotalCnt++;

		out.write(strRecord);
		out.newLine();
		out.flush();

	}

	public void writeFooter() throws IOException {
		strTrailer = "";
		strTrailerFix = "FF";
		strTrailerTotalRecord = StringUtils.leftPad(String.valueOf(iTotalCnt), 12, "0");
		strTrailerTotalAmount = StringUtils.leftPad(String.valueOf(iTotalAmt), 12, "0");
		strTrailerTotalHash = StringUtils.leftPad(String.valueOf(iHashTot), 12, "0");
		strTrailerBankUse = StringUtils.rightPad("", 42, " ");

		strTrailer = strTrailerFix + strTrailerTotalRecord + strTrailerTotalAmount + strTrailerTotalHash
				+ strTrailerBankUse;

		out.write(strTrailer);
		out.newLine();
		out.flush();
	}
}
