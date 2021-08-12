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

public class ECashGrpDeductionFileCIMBHandler extends BasicTextDownloadHandler implements ResultHandler<Map<String, Object>> {
	private static final Logger LOGGER = LoggerFactory.getLogger(ClaimFileCrcCIMBHandler.class);

	// 본문 작성을 위한 변수
	String stext = "";
	String crcOwner = "";
	String crcNo = "";
	String crcExpiry = "";
	String amount = "";
	String salesOrdNo = "";
	String remarks = "";

	public ECashGrpDeductionFileCIMBHandler(FileInfoVO fileInfoVO, Map<String, Object> params) {
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
		LOGGER.debug("write Header complete.....");
	}

	private void writeBody(ResultContext<? extends Map<String, Object>> result) throws IOException {
		Map<String, Object> dataRow = result.getResultObject();

		// 본문 작성
		crcOwner = " ";

		// ISSUE : 암호화 RULE 규정
		// String CrcNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).Trim();
		crcNo = String.valueOf(dataRow.get("fileItmAccNo")).trim();
		//crcExpiry = "0000";
		crcExpiry = dataRow.get("fileItmAccExpr") == null ? "0000" : String.valueOf(dataRow.get("fileItmAccExpr")).trim();
		amount = CommonUtils.getNumberFormat(String.valueOf(dataRow.get("fileItmAmt")), "0.00");
		salesOrdNo = "0000";
		remarks = String.valueOf(dataRow.get("fileBatchGrpId"));

		//stext = crcOwner + "," + crcNo + "," + crcExpiry + ",$" + amount + "," + salesOrdNo + "," + remarks;

		// 2020-03-19 - LaiKW - MC Payment Tokenization Format
		stext = crcOwner + "," + crcNo + ",$" + amount + "," + salesOrdNo + "," + remarks;

		out.write(stext);
		out.newLine();
		out.flush();
	}

}
