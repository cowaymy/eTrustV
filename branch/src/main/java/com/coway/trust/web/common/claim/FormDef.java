package com.coway.trust.web.common.claim;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;

public class FormDef {

	private FormDef() {
	}

	public static FileInfoVO getTextDownloadVO(String fileName, String[] columnNames, String[] titleNames) {
		checkParams(fileName);
		FileInfoVO fileVO = readTextDownloadVO(fileName, columnNames, titleNames);
		return fileVO;
	}

	private static void checkParams(String fileName) {
		if (StringUtils.isEmpty(fileName)) {
			throw new ApplicationException(AppConstants.FAIL, "fileName is required.!!");
		}
	}

	private static FileInfoVO readTextDownloadVO(String fileName, String[] columnNames, String[] titleNames) {
		FileInfoVO fileInfoVO = setHeader(fileName);
		List<ColumnVO> columns = new ArrayList<>();
		List<HeaderVO> headers = new ArrayList<>();
		fileInfoVO.setTextColumns(columns);
		fileInfoVO.setTextHeaders(headers);
		setColumnInfo(columns, headers, columnNames, titleNames);
		return fileInfoVO;
	}

	private static void setColumnInfo(List<ColumnVO> columns, List<HeaderVO> headers, String[] columnNames,
			String[] titleNames) {

		ColumnVO textColumnVo;
		HeaderVO textHeaderVo;

		for (String name : columnNames) {
			textColumnVo = new ColumnVO();
			textColumnVo.setColumnName(name);
			columns.add(textColumnVo);
		}

		if (titleNames != null) {
			for (String titleName : titleNames) {
				textHeaderVo = new HeaderVO();
				textHeaderVo.setTitleName(titleName);
				headers.add(textHeaderVo);
			}
		}
	}

	private static FileInfoVO setHeader(String fileName) {
		FileInfoVO fileInfoVO = new FileInfoVO();
		fileInfoVO.setTextFilename(fileName);
		return fileInfoVO;
	}
}
