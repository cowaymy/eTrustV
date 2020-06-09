package com.coway.trust.web.common.claim;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
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

public class ECashGrpDeductionFileMBBHandler extends BasicTextDownloadHandler implements ResultHandler<Map<String, Object>> {
	private static final Logger LOGGER = LoggerFactory.getLogger(ECashGrpDeductionFileMBBHandler.class);

	// Header
	String messageType = "";
	String sbatchNo = "";
	String merOrg = "";
	String merId = "";
	String merName = "";
	String merCode = "";
	String noOfTrans = "";
	String totAmt= "";
	String batchStus= "";
	String termId = "";
	String ccy = "";
	String reserved = "";
	String settleBatch= "";
	String filter1 = "";
	String settleTerm = "";
	String filter2 = "";
	String ret = "";
	String inputDate = "";

	String sSecCode = "";
	String sText = "";

	// Body
	String stextDetails = "";
	String bMessageType = "";
	String bBatchNo = "";
	String bTransNo = "";
	String bTransCode = "";
	String bAccNo = "";
	String bAmount = "";
	String bExpiredDt = "";
	String bPosEntry = "";
	String bApprovalCode = "";
	String bResponseCode = "";
	String bMode = "";
	String bOfflineStus = "";
	String bDate = "";
	String bTime = "";
	String bRefNo = "";
	String bRemark = "";
	String bCvv = "";
	String bProductCode = "";
	//String ret = "";


	long sLimit = 0;
	long fLimit = 0;
	long iTotalAmt = 0;
	long ihashtot3 = 0;
	int iTotalCnt = 0;

	// footer 작성
	String fMessage = "";
	String sNoOfBatch = "";
	String sRecTot = "";
	String sBatchTot = "";
	String sFiller = "";
	int endIndex = 0;
	String sTextBtn = "";

	BigDecimal fTotalAmt = null;
	BigDecimal amount = null;
	BigDecimal hunred = new BigDecimal(100);

	public ECashGrpDeductionFileMBBHandler(FileInfoVO fileInfoVO, Map<String, Object> params) {
		super(fileInfoVO, params);
	}

	@Override
	public void handleResult(ResultContext<? extends Map<String, Object>> result) {
		try {
			if (!isStarted) {
                init(String.valueOf(params.get("type")));
                writeHeader(result, String.valueOf(params.get("type")));
                isStarted = true;
            }

			writeBody(result, String.valueOf(params.get("type")));

		} catch (Exception e) {
			throw new ApplicationException(e, AppConstants.FAIL);
		}
	}

	private void init(String Type) throws IOException {
		out = createFile(Type);
	}

    BufferedWriter createFile(String type) throws IOException {
        File file = new File(fileInfoVO.getFilePath() + fileInfoVO.getSubFilePath() + fileInfoVO.getTextFilename());

        // figure out how to handle
        if (!file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }

        // append true
        if("1".equals(type)) {
            fileWriter = new FileWriter(file);
        } else {
            fileWriter = new FileWriter(file, true);
        }
        return new BufferedWriter(fileWriter);
    }

	private void writeHeader(ResultContext<? extends Map<String, Object>> result, String type) throws IOException {
		Map<String, Object> dataRow = result.getResultObject();
		BigDecimal totA = (BigDecimal)dataRow.get("totAmt");
		long limit = totA.multiply(hunred).longValue();

		// 헤더 작성
		messageType	= StringUtils.rightPad(String.valueOf("H"), 1, " ");
	    if("1".equals(type)) {
	        sbatchNo   = StringUtils.leftPad(String.valueOf("1"), 5, "0");
	    } else {
	        sbatchNo   = StringUtils.leftPad(String.valueOf(dataRow.get("pageno")), 5, "0");
	    }
		merOrg 			= StringUtils.rightPad(String.valueOf("001"), 3, " ");
		//merId 			= StringUtils.rightPad(String.valueOf("060012051"), 1, " ");
		merId 			= StringUtils.rightPad(String.valueOf("060013831"), 1, " ");
		merName 		= StringUtils.rightPad(String.valueOf("COWAY (M) SDN BHD"), 20, " ");
		//merCode 		= StringUtils.rightPad(String.valueOf("7523"), 4, " ");
		merCode 		= StringUtils.rightPad(String.valueOf("5722"), 4, " ");
		noOfTrans 		= StringUtils.leftPad(String.valueOf(dataRow.get("totItm")), 6, "0");
		totAmt			= StringUtils.leftPad(String.valueOf(limit), 13, "0");
		batchStus		= StringUtils.rightPad(String.valueOf("N"), 1, " ");
		termId 			= StringUtils.rightPad(String.valueOf(""), 20, " ");
		ccy 				= StringUtils.rightPad(String.valueOf("458"), 3, " ");
		reserved 		= StringUtils.rightPad(String.valueOf("000000"), 6, " ");
		settleBatch		= StringUtils.rightPad(String.valueOf("000000"), 6, " ");
		filter1 			= StringUtils.rightPad(String.valueOf(""), 2, " ");
		settleTerm 		= StringUtils.rightPad(String.valueOf(""), 8, " ");
		filter2 			= StringUtils.rightPad(String.valueOf(""), 18, " ");
//		ret 				= StringUtils.rightPad("", 1, "");

		//sSecCode = StringUtils.leftPad(String.valueOf((Integer.parseInt(sbatchNo) + 1208083646)), 10, " ");

		sText = messageType + sbatchNo + merOrg + merId + merName + merCode + noOfTrans + totAmt + batchStus + termId + ccy + reserved +  settleBatch + filter1 + settleTerm + filter2;

		out.write(sText);
		out.newLine();
		out.flush();

		LOGGER.debug("write Header complete.....");
	}

	private void writeBody(ResultContext<? extends Map<String, Object>> result, String type) throws IOException {
		Map<String, Object> dataRow = result.getResultObject();

		String crcExpiry = StringUtils.isEmpty(String.valueOf(dataRow.get("fileItmAccExpr"))) ? "0000" : String.valueOf(dataRow.get("fileItmAccExpr"));

		bMessageType = StringUtils.rightPad("T", 1, " ");
		if("1".equals(type)) {
            bBatchNo    = StringUtils.leftPad(String.valueOf("1"), 5, "0");
        } else {
            bBatchNo    = StringUtils.leftPad(String.valueOf(dataRow.get("pageno")), 5, "0");
        }
		//bTransNo 		= StringUtils.leftPad(String.valueOf(dataRow.get("rnum")), 6, "0");
		bTransCode 	= StringUtils.rightPad("40", 2, " ");
//		bAccNo 			= StringUtils.rightPad(String.valueOf(dataRow.get("fileItmAccNo")), 19, " "); // To comment for MCP
		bAccNo            = StringUtils.rightPad(String.valueOf(dataRow.get("fileItmAccNo")), 36, " "); // To uncomment for MCP
		//bAmount 		= StringUtils.rightPad(String.valueOf("1"), 13, " ");
//		bExpiredDt 		= StringUtils.rightPad(String.valueOf(crcExpiry), 4, " "); // To comment for MCP
		bPosEntry 		= StringUtils.rightPad(String.valueOf("01"), 2, " ");
		bApprovalCode= StringUtils.rightPad("", 6, " ");
		bResponseCode= StringUtils.rightPad("", 2, " ");
		bMode 			= StringUtils.rightPad("", 1, " ");
		bOfflineStus 	= StringUtils.rightPad("", 1, " ");
		bDate 			= StringUtils.rightPad("", 6, " ");
		bTime 			= StringUtils.rightPad("", 6, " ");
		bRefNo 			= StringUtils.rightPad(String.valueOf(dataRow.get("fileBatchGrpId")), 15, " ");
		bRemark 		= StringUtils.rightPad("", 18, " ");
		bCvv 				= StringUtils.rightPad("", 3, " ");
		bProductCode = StringUtils.rightPad("", 15, " ");
//		ret 				= StringUtils.rightPad("", 1, "");;

		//금액 계산
		amount = (BigDecimal)dataRow.get("fileItmAmt");
		sLimit = amount.multiply(hunred).longValue();

		iTotalAmt = iTotalAmt + sLimit;
//		ihashtot3 = ihashtot3 + sLimit + Long.parseLong(bAccNo.trim()); // To comment for MCP
		iTotalCnt++;
		bTransNo 		= StringUtils.leftPad(String.valueOf(iTotalCnt), 6, "0");
		bAmount = StringUtils.leftPad(String.valueOf(sLimit), 13, "0");


		stextDetails = bMessageType + bBatchNo + bTransNo + bTransCode + bAccNo + bAmount + bExpiredDt + bPosEntry
				+ bApprovalCode + bResponseCode + bMode + bOfflineStus + bDate + bTime + bRefNo + bRemark + bCvv + bProductCode;

		out.write(stextDetails);
		out.newLine();
		out.flush();



	}

	public void writeFooter(String type) throws IOException {

		fTotalAmt = (BigDecimal)params.get("fileBatchTotAmt");
		fLimit = fTotalAmt.multiply(hunred).longValue();

		fMessage = "R";
		if("1".equals(type)) {
            sNoOfBatch =StringUtils.leftPad(String.valueOf("1"),3,"0");
        } else {
            sNoOfBatch =StringUtils.leftPad(String.valueOf(params.get("pageNo")),3,"0");
        }
		//sRecTot    = StringUtils.leftPad(String.valueOf(iTotalCnt), 7, "0");
		sRecTot    = StringUtils.leftPad(String.valueOf(params.get("fileBatchTotRcord")), 7, "0");
		//sBatchTot = StringUtils.leftPad(String.valueOf(iTotalAmt), 13, "0");
		sBatchTot = StringUtils.leftPad(String.valueOf(fLimit), 13, "0");
//		sFiller      = StringUtils.leftPad("", 101, " ");
		sFiller      = StringUtils.leftPad("", 101, " ");
//		ret  		  = StringUtils.leftPad("", 1, "");

		sTextBtn = fMessage + sNoOfBatch + sRecTot + sBatchTot + sFiller;

		out.write(sTextBtn);
		out.newLine();
		out.flush();

	}
}
