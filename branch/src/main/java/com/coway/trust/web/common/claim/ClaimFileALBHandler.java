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

public class ClaimFileALBHandler extends BasicTextDownloadHandler implements ResultHandler<Map<String, Object>> {
	private static final Logger LOGGER = LoggerFactory.getLogger(ClaimFileALBHandler.class);
	
	// 본문 작성
	private String stextDetails = "";
	private String sDrAccNo = "";
	private String sLimit = "";
	private String sDocno = "";
	private String sBillDate = "";
	
	//footer를 위한 변수
	private double iTotalAmt = 0.0D;
	private int iTotalCount = 0;
	

	public ClaimFileALBHandler(FileInfoVO fileInfoVO, Map<String, Object> params) {
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
		String sText = "H|AUTODEBIT|";
		
		out.write(sText);
		out.newLine();
		out.flush();
		
		LOGGER.debug("write Header complete.....");
	}

	private void writeBody(ResultContext<? extends Map<String, Object>> result) throws IOException {
		Map<String, Object> dataRow = result.getResultObject();
		
		// ISSUE : 암호화 RULE 규정
		// sDrAccNo = EncryptionProvider.Decrypt(det.AccNo.Trim()).ToString().Trim().PadLeft(15, ' ');
		sDrAccNo = StringUtils.leftPad(String.valueOf(dataRow.get("bankDtlDrAccNo")) , 15, " ");

		sLimit = CommonUtils.getNumberFormat(String.valueOf(dataRow.get("bankDtlAmt")), "0.00");
		sBillDate = dataRow.get("bankDtlDrDt") != null ? (String) dataRow.get("bankDtlDrDt") : "1900-01-01";
		sDocno = (String) dataRow.get("cntrctNOrdNo");
		stextDetails = "D|101|" + sDrAccNo + "|" + sLimit + "|" + CommonUtils.changeFormat(sBillDate, "yyyy-MM-dd", "ddMMyyyy") + "| |" + sDocno + "|";
		
		//footer를 작성하기 위한 변수 세팅
		iTotalAmt = iTotalAmt + Double.parseDouble(sLimit);
		iTotalCount++;

		out.write(stextDetails);
		out.newLine();
		out.flush();
			
	}

	public void writeFooter() throws IOException {
		// footer 작성
		String sTextBtn = "T|" + iTotalCount + "|" + CommonUtils.getNumberFormat(iTotalAmt, "0.00") + "|";
		
		out.write(sTextBtn);
		out.newLine();
		out.flush();
	}
}
