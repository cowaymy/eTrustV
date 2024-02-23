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

public class ECashGrpDeductionFileAMBHandler extends BasicTextDownloadHandler implements ResultHandler<Map<String, Object>> {
  private static final Logger LOGGER = LoggerFactory.getLogger(ECashGrpDeductionFileAMBHandler.class);

  // Header
  String recordType = "";
  String fileName = "";
  String fileDate = "";
  String fileNumber = "";
  String processingType = "";
  String merchantNumber = "";
  String terminalPoolId = "";
  String transactionType= "";
  String filter= "";
  String eolCharacter = "";

  String sText = "";

  // Body
  String bRecordType = "";
  String bTransactionSeqNumber = "";
  String bCreditCardLength = "";
  String bTokenId = "";
  String bTransactionDesciption = "";
  String bTransactionAmount = "";
  String bEppProgramCode = "";
  String bEppTotalAmount = "";
  String bEppDownPaymentAmount = "";
  String bFilter = "";
  String bEolCharacter = "";

  String stextDetails = "";

  // footer 작성
  String sRecordType = "";
  String sNoOfRecords = "";
  String sTotalAmount = "";
  String sHashTotal = "";
  String sFiller = "";
  String sEolCharacter = "";

  String sTextBtn = "";
  BigDecimal hunred = new BigDecimal(100);
  long fLimit = 0;
  BigDecimal fTotalAmt = null;

  public ECashGrpDeductionFileAMBHandler(FileInfoVO fileInfoVO, Map<String, Object> params) {
    super(fileInfoVO, params);
  }

  @Override
  public void handleResult(ResultContext<? extends Map<String, Object>> result) {
    try {
      if (!isStarted) {
                init();
                writeHeader(result);
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

  private void writeHeader(ResultContext<? extends Map<String, Object>> result) throws IOException {
    Map<String, Object> dataRow = result.getResultObject();

    // 헤더 작성
    recordType      = StringUtils.rightPad(String.valueOf("H"),  1, " ");
    fileName        = StringUtils.rightPad(String.valueOf(""),  10, " ");
    fileDate        = StringUtils.rightPad(String.valueOf(dataRow.get("filedate")),   8, " ");
    fileNumber      = StringUtils.leftPad(String.valueOf(dataRow.get("pageno")),   2, "0");
    processingType  = StringUtils.rightPad(String.valueOf("S"),   1, " ");
    merchantNumber  = StringUtils.rightPad(String.valueOf("000009140549436"),  15, " ");
    terminalPoolId  = StringUtils.rightPad(String.valueOf("48109424"),   8, " ");
    transactionType = StringUtils.rightPad(String.valueOf("R"),   1, " ");
    filter          = StringUtils.rightPad(String.valueOf(""), 154, " ");
    eolCharacter    = StringUtils.rightPad(String.valueOf("\\n"),   2, " ");

    sText = recordType + fileName + fileDate + fileNumber + processingType + merchantNumber + terminalPoolId + transactionType + filter + eolCharacter;

    out.write(sText);
    out.newLine();
    out.flush();

    LOGGER.debug("write Header complete.....");
  }

  private void writeBody(ResultContext<? extends Map<String, Object>> result) throws IOException {
    Map<String, Object> dataRow = result.getResultObject();
    BigDecimal totA = (BigDecimal)dataRow.get("fileItmAmt");
    long limit = totA.multiply(hunred).longValue();

    bRecordType            = StringUtils.rightPad(String.valueOf("D"),  1, " ");
    bTransactionSeqNumber  = StringUtils.leftPad(String.valueOf(dataRow.get("rnum")), 7, "0");
    bCreditCardLength      = StringUtils.rightPad(String.valueOf("16"), 2, " ");
    bTokenId               = StringUtils.rightPad(String.valueOf(dataRow.get("fileItmAccNo")), 36, " ");
    bTransactionDesciption = StringUtils.leftPad(String.valueOf(dataRow.get("fileBatchGrpId")), 40, " ");
    bTransactionAmount     = StringUtils.leftPad(String.valueOf(limit), 12, "0");
    bEppProgramCode        = StringUtils.rightPad(String.valueOf(""), 4, " ");
    bEppTotalAmount        = StringUtils.rightPad(String.valueOf(""), 9, " ");
    bEppDownPaymentAmount  = StringUtils.rightPad(String.valueOf(""), 9, " ");
    bFilter                = StringUtils.rightPad(String.valueOf(""), 93, " ");
    bEolCharacter          = StringUtils.rightPad(String.valueOf("\\n"), 2, " ");


    stextDetails = bRecordType + bTransactionSeqNumber + bCreditCardLength + bTokenId + bTransactionDesciption + bTransactionAmount + bEppProgramCode + bEppTotalAmount + bEppDownPaymentAmount
        + bFilter + bEolCharacter ;

    out.write(stextDetails);
    out.newLine();
    out.flush();

  }

  public void writeFooter() throws IOException {

    fTotalAmt = (BigDecimal)params.get("fileBatchTotAmt");
    fLimit = fTotalAmt.multiply(hunred).longValue();

    sRecordType     = StringUtils.rightPad(String.valueOf("T"),  1, " ");
    sNoOfRecords    = StringUtils.leftPad(String.valueOf(params.get("fileBatchTotRcord")),  6, "0");
    sTotalAmount    = StringUtils.leftPad(String.valueOf(fLimit),  18, "0");
    sHashTotal      = StringUtils.rightPad(String.valueOf(""),  18, " ");
    sFiller         = StringUtils.rightPad(String.valueOf(""),  157, " ");
    sEolCharacter   = StringUtils.rightPad(String.valueOf("\\n"),  2, " ");

    sTextBtn = sRecordType + sNoOfRecords + sTotalAmount + sHashTotal + sFiller + sEolCharacter;

    out.write(sTextBtn);
    out.newLine();
    out.flush();

  }
}
