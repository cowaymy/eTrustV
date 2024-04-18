package com.coway.trust.web.common.claim;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.ibatis.session.ResultContext;
import org.apache.ibatis.session.ResultHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class ECashGrpDeductionFileHSBCHandler extends BasicTextDownloadHandler
		implements ResultHandler<Map<String, Object>> {
	private static final Logger LOGGER = LoggerFactory.getLogger(ECashGrpDeductionFileHSBCHandler.class);

	// FOR HEADER
	private String strHeader = "";
	private String strData = "";

	// FOR DETAIL
	private String strRecord = "";
	private String strDtlData = "";

	private BigDecimal iTotalAmt = new BigDecimal(0);
	int iTotalCnt = 0;

	private BigDecimal iTotalInvAmt = new BigDecimal(0);
	int iTotalInvCnt = 0;

	// FOR FOOTER
	private Map<String, Object> tData;
	private String strTrailer = "";

	List<EgovMap> headerInfo; // TO KEEP HEADER CONFIGURATION
	List<EgovMap> datailInfo; // TO KEEP DETAIL CONFIGURATION
	List<EgovMap> trailerInfo; // TO KEEP TRAILER CONFIGURATION

	public ECashGrpDeductionFileHSBCHandler(FileInfoVO fileInfoVO, List<EgovMap> headerInfo, List<EgovMap> datailInfo,
			List<EgovMap> trailerInfo, Map<String, Object> params) {
		super(fileInfoVO, params);
		this.headerInfo = headerInfo;
		this.datailInfo = datailInfo;
		this.trailerInfo = trailerInfo;
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

	BufferedWriter createFile(String type) throws IOException {
		File file = new File(fileInfoVO.getFilePath() + fileInfoVO.getSubFilePath() + fileInfoVO.getTextFilename());

		// figure out how to handle
		if (!file.getParentFile().exists()) {
			file.getParentFile().mkdirs();
		}

		// append true
		if ("1".equals(type)) {
			fileWriter = new FileWriter(file);
		} else {
			fileWriter = new FileWriter(file, true);
		}
		return new BufferedWriter(fileWriter);
	}

	private void writeHeader(ResultContext<? extends Map<String, Object>> result) throws IOException {
		// HEADER
		strHeader = "";
		strData = "";
		Map<String, Object> dataRow = result.getResultObject();

		if (headerInfo != null) {
			if (headerInfo.size() > 0) {
				for (int a = 0; a < headerInfo.size(); a++) {
					Map<String, Object> headerConf = new HashMap<String, Object>();
					headerConf = (Map<String, Object>) headerInfo.get(a);

					strData = this.dataReplace(headerConf, dataRow);
					strData = this.dataProcessor(headerConf, strData);
					strHeader += strData;
				}
			}

			out.write(strHeader);
			out.newLine();
			out.flush();
		}
	}

	private void writeBody(ResultContext<? extends Map<String, Object>> result) throws IOException {
		Map<String, Object> dataRow = result.getResultObject();

		// DETAIL
		strDtlData = "";
		strRecord = "";

		if (datailInfo != null) {
			if (datailInfo.size() > 0) {
				for (int b = 0; b < datailInfo.size(); b++) {
					Map<String, Object> detailConf = new HashMap<String, Object>();
					detailConf = (Map<String, Object>) datailInfo.get(b);

					strDtlData = this.dataReplace(detailConf, dataRow);

					//Special case handling for converting amount to hundred value
					if(CommonUtils.nvl(detailConf.get("ctrlDat")).toString().trim().equals("{fileItmAmt}")){
						strDtlData = this.hundredValueProcess(detailConf, strDtlData);
					}

					strDtlData = this.dataProcessor(detailConf, strDtlData);

					strRecord += strDtlData;
				}
			}

			iTotalAmt = iTotalAmt.add((java.math.BigDecimal) dataRow.get("fileItmAmt"));
			iTotalCnt++;

			out.write(strRecord);
			out.newLine();
			out.flush();
		}
	}

	  public void writeFooter() throws IOException {
		    strTrailer = "";
		    String StrFtData = "";

		    tData = new HashMap<String, Object>();
		    tData.put("tTotalRecord", String.valueOf(iTotalCnt));
		    tData.put("tTotalCollectionAmt", String.valueOf(iTotalAmt));
		    tData.put("tTotalInvRecord", String.valueOf(iTotalInvAmt));
		    tData.put("tTotalInvCollectionAmt", String.valueOf(iTotalInvAmt));

		    if (trailerInfo != null) {
		      if (trailerInfo.size() > 0) {
		        for (int a = 0; a < trailerInfo.size(); a++) {
		          Map<String, Object> footConf = new HashMap<String, Object>();
		          footConf = (Map<String, Object>) trailerInfo.get(a);
		          StrFtData = this.dataReplace(footConf, tData);
		          StrFtData = this.dataProcessor(footConf, StrFtData);
		          strTrailer += StrFtData;

		        }
		      }
		    }

		    out.write(strTrailer);
		    out.newLine();
		    out.flush();
		  }

	private String dataReplace(Map<String, Object> conf, Map<String, Object> dtRow) {
		String str = "";

		str = CommonUtils.nvl(conf.get("ctrlDat")).toString().trim();

		if (str.contains("{") && str.contains("}")) {
			str = (str.replace("{", "")).replace("}", "");
			if (dtRow != null) {
				str = String.valueOf(dtRow.get(str)).trim();
			}
		}
		return str;
	}

	private String dataProcessor(Map<String, Object> conf, String strDtlData) {
		String str = "";

		// DATA TYPE :: S - STRING; N - NUMERIC; D - DATE
		if ((CommonUtils.nvl(conf.get("ctrlDatTyp")).toString().toUpperCase()).equals("S")) {
			str = this.padProcessor(conf, strDtlData);
		} else if ((CommonUtils.nvl(conf.get("ctrlDatTyp")).toString().toUpperCase()).equals("N")) {
			str = CommonUtils.getNumberFormat(String.valueOf(strDtlData),
					(CommonUtils.nvl(conf.get("ctrlDatFmt")).equals("") ? "0.00"
							: CommonUtils.nvl(conf.get("ctrlDatFmt")).toString()));
			str = this.padProcessor(conf, str);
		} else if ((CommonUtils.nvl(conf.get("ctrlDatTyp")).toString().toUpperCase()).equals("D")) {
			str = CommonUtils.changeFormat(strDtlData, "yyyy-MM-dd", (CommonUtils.nvl(conf.get("ctrlDatFmt")).equals("")
					? "yyyyMMdd" : CommonUtils.nvl(conf.get("ctrlDatFmt")).toString()));
			str = this.padProcessor(conf, str);
		}
		if (!CommonUtils.nvl(conf.get("ctrlDelimeter")).equals("")) {
			str = str + conf.get("ctrlDelimeter");
		}
		return str;
	}

	private String padProcessor(Map<String, Object> conf, String strDtlData) {
		String str = "";

		if ((CommonUtils.nvl(conf.get("ctrlPad")).toString().toUpperCase()).equals("L")) { // LEFT
																						   // PAD
			str = StringUtils.leftPad(strDtlData, Integer.parseInt(CommonUtils.nvl(conf.get("ctrlDatLgth")).toString()),
					(CommonUtils.nvl(conf.get("ctrlPadVal")).equals("") ? " "
							: CommonUtils.nvl(conf.get("ctrlPadVal")).toString()));
		} else if ((CommonUtils.nvl(conf.get("ctrlPad")).toString().toUpperCase()).equals("R")) { // RIGHT
																								  // PAD
			str = StringUtils.rightPad(strDtlData,
					Integer.parseInt(CommonUtils.nvl(conf.get("ctrlDatLgth")).toString()),
					(CommonUtils.nvl(conf.get("ctrlPadVal")).equals("") ? " "
							: CommonUtils.nvl(conf.get("ctrlPadVal")).toString()));
		} else {
			str = strDtlData;
		}
		return str;
	}

	private String hundredValueProcess(Map<String, Object> conf, String strDtlData) {
		String str = "";
		BigDecimal hunred = new BigDecimal(100);
		BigDecimal amount = BigDecimal.valueOf(Double.valueOf(strDtlData));

		str = String.valueOf(amount.multiply(hunred).longValue());
		return str;
	}
}
