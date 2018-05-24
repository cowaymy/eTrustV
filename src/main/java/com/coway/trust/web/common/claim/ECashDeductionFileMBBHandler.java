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

public class ECashDeductionFileMBBHandler extends BasicTextDownloadHandler implements ResultHandler<Map<String, Object>>
{
	private static final Logger LOGGER = LoggerFactory.getLogger(ECashDeductionFileMBBHandler.class);

	String inputDate = "";
	String strHeader = "";
	String strHeaderRecType = "";
	String strHeaderVolume = "";
	String strHeaderCompanyID = "";
	String strHeaderCompanyDesc = "";
	String strHeaderBillDate = "";
	String strHeaderMerchantID = "";
	String strHeaderBankUse = "";

	String strBody = "";
	String recType = "";
	String accNo = "";
	String chkDigit = "";
	String billamt = "";
	String crcNo = "";
	String bCycle = "";
	String bCode = "";
	String bankUse = "";

	BigDecimal amount = null;
	BigDecimal hundred = new BigDecimal(100);


	long iHashTot = 0;
	long iTotalAmt = 0;
	int iTotalCnt = 0;

	String strFooter = "";
	String strFooterRecType = "";
	String strFooterTotItm = "";
	String strFooterTotAmt = "";
	String strFooterTotHash = "";
	String strFooterBankUse = "";

	public ECashDeductionFileMBBHandler(FileInfoVO fileInfoVO, Map<String, Object> params)
	{
		super(fileInfoVO, params);
	}

	@Override
	public void handleResult(ResultContext<? extends Map<String, Object>> result)
	{
		try
		{
			if (!isStarted)
			{
				init();
				writeHeader();
				isStarted = true;
			}

			writeBody(result);

		}
		catch (Exception e)
		{
			throw new ApplicationException(e, AppConstants.FAIL);
		}
	}

	private void init() throws IOException
	{
		out = createFile();
	}

	private void writeHeader() throws IOException
	{
		inputDate = CommonUtils.nvl(params.get("ctrlBatchDt")).equals("") ? "1900-01-01" : (String) params.get("ctrlBatchDt");

		strHeaderRecType = "1";
		strHeaderVolume = "00";
		strHeaderCompanyID = "00";
		strHeaderCompanyDesc = StringUtils.rightPad("WOONGJIN COWAY", 15, " ");

		strHeaderBillDate = CommonUtils.changeFormat(inputDate, "yyyy-MM-dd", "ddMMyy");
		strHeaderMerchantID = StringUtils.rightPad("02172", 9, " ");
		strHeaderBankUse = StringUtils.rightPad("", 43, " ");

		strHeader = strHeaderRecType + strHeaderVolume + strHeaderCompanyID +
							strHeaderCompanyDesc + strHeaderBillDate + " " + strHeaderMerchantID + strHeaderBankUse;

		out.write(strHeader);
		out.newLine();
		out.flush();

		LOGGER.debug("Write Header complete.....");
	}

	private void writeBody(ResultContext<? extends Map<String, Object>> result) throws IOException
	{
		Map<String, Object> dataRow = result.getResultObject();

		recType = "2";
		accNo = StringUtils.rightPad(String.valueOf(dataRow.get("fileItmId")).trim(), 15, " ");
		amount = (BigDecimal)dataRow.get("fileItmAmt");
		billamt = StringUtils.leftPad(String.valueOf(amount.multiply(hundred).longValue()), 12, "0");
		crcNo = String.valueOf(dataRow.get("fileItmAccNo")).trim();

		strBody = recType + accNo + " " + billamt + crcNo + bCycle + bCode + bankUse;

		iHashTot = iHashTot + Long.parseLong(CommonUtils.right(String.valueOf(dataRow.get("fileItmAccNo")).trim(), 4));
		iTotalAmt = iTotalAmt + amount.multiply(hundred).longValue();
		iTotalCnt++;

		out.write(strBody);
		out.newLine();
		out.flush();
	}

	public void writeFooter() throws IOException
	{
		strFooterRecType = "3";
		strFooterTotItm = StringUtils.leftPad(String.valueOf(iTotalCnt), 5, "0");
		strFooterTotAmt = StringUtils.leftPad(String.valueOf(iTotalAmt), 12, "0");
		strFooterTotHash = StringUtils.leftPad(String.valueOf(iHashTot), 12, "0");
		strFooterBankUse = StringUtils.rightPad("", 49, " ");

		strFooter = strFooterRecType + strFooterTotItm + strFooterTotAmt + strFooterTotHash + strFooterBankUse;

		out.write(strFooter);
		out.newLine();
		out.flush();
	}
}