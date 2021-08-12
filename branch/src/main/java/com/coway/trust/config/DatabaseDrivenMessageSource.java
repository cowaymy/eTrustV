package com.coway.trust.config;

import java.text.MessageFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ResourceLoaderAware;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.core.io.ResourceLoader;

import com.coway.trust.biz.common.CommonService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class DatabaseDrivenMessageSource extends AbstractMessageSource implements ResourceLoaderAware {

	private static final Logger LOGGER = LoggerFactory.getLogger(DatabaseDrivenMessageSource.class);

	private ResourceLoader resourceLoader;

	private final Map<String, Map<String, String>> properties = new HashMap<>();

	@Resource(name = "commonService")
	private CommonService commonService;

	public DatabaseDrivenMessageSource() {
		// reload();
	}
	
	public ResourceLoader getResourceLoader() {
		return resourceLoader;
	}

	@PostConstruct
	public void init() {
		reload();
	}

	@Override
	protected MessageFormat resolveCode(String code, Locale locale) {
		String msg = getText(code, locale);
		MessageFormat result = createMessageFormat(msg, locale);
		return result;
	}

	@Override
	protected String resolveCodeWithoutArguments(String code, Locale locale) {
		return getText(code, locale);
	}

	private String getText(String code, Locale locale) {
		Map<String, String> localized = properties.get(code);
		String textForCurrentLanguage = null;
		if (localized != null) {
			textForCurrentLanguage = localized.get(locale.getLanguage());
			if (textForCurrentLanguage == null) {
				textForCurrentLanguage = localized.get(Locale.ENGLISH.getLanguage());
			}
		}
		if (textForCurrentLanguage == null) {
			// Check parent message
			logger.debug("Fallback to properties message");
			try {
				textForCurrentLanguage = getParentMessageSource().getMessage(code, null, locale);
			} catch (Exception e) {
				logger.error("Cannot find message with code: " + code);
			}
		}
		return textForCurrentLanguage != null ? textForCurrentLanguage : code;
	}

	public void reload() {
		properties.clear();
		properties.putAll(loadTexts());
	}

	protected Map<String, Map<String, String>> loadTexts() {
		LOGGER.debug("loadTexts");
		List<EgovMap> list = commonService.selectI18NList();
		Messages messages = extractI18NData(list);
		return messages.getMessages();
	}

	@Override
	public void setResourceLoader(ResourceLoader resourceLoader) {
		this.resourceLoader = (resourceLoader != null ? resourceLoader : new DefaultResourceLoader());
	}

	protected Messages extractI18NData(List<EgovMap> list) {
		Messages messages = new Messages();

		for (EgovMap eMap : list) {
			messages.addMessage((String) eMap.get("id"), (String) eMap.get("language"), (String) eMap.get("message"));
		}
		return messages;
	}

	/**
	 * 
	 * Messages bundle
	 */
	protected static final class Messages {

		private Map<String, Map<String, String>> messages;

		public void addMessage(String code, String locale, String msg) {
			if (messages == null)
				messages = new HashMap<String, Map<String, String>>();

			Map<String, String> data = messages.get(code);
			if (data == null) {
				data = new HashMap<String, String>();
				messages.put(code, data);
			}

			data.put(locale, msg);
		}

		public Map<String, Map<String, String>> getMessages() {
			return this.messages;
		}

		public String getMessage(String code, String locale) {
			Map<String, String> data = messages.get(code);
			return data != null ? data.get(locale) : null;
		}
	}
}
