package com.coway.trust.biz.common;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.StringUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;

public class EmailVO {

	private String from;
	private List<String> to = new ArrayList<>();
	private String subject;
	private String text;
	private boolean isHtml;
	private List<File> files = new ArrayList<>();

	public String getFrom() {
		if (StringUtils.isEmpty(this.from)) {
			throw new ApplicationException(AppConstants.FAIL, "IllegalArgumentException");
		}
		return from;
	}

	public void setFrom(String from) {
		this.from = from;
	}

	public List<String> getTo() {
		if (this.to == null || this.to.size() == 0) {
			throw new ApplicationException(AppConstants.FAIL, "IllegalArgumentException");
		}
		return to;
	}

	public void setTo(String to) {
		this.to.add(to);
	}

	public void setTo(List<String> to) {
		this.to = to;
	}

	public void addTo(String to) {
		this.to.add(to);
	}

	public void addTo(List<String> to) {
		this.to.addAll(to);
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getText() {
		if (StringUtils.isEmpty(this.text)) {
			throw new ApplicationException(AppConstants.FAIL, "IllegalArgumentException");
		}
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public boolean isHtml() {
		return isHtml;
	}

	public void setHtml(boolean isHtml) {
		this.isHtml = isHtml;
	}

	public void addFile(File file) {
		this.files.add(file);
	}

	public void addFiles(List<File> files) {
		this.files.addAll(files);
	}

	public List<File> getFiles() {
		return this.files;
	}
}
