#pragma once
#include <string>
#include <list>
#include <sstream>
#include <vector>
#include <map>
#include "Singleton.h"
#include "support/tinyxml2/tinyxml2.h"

/**
//usage example

struct DATA
{
	int id;
	std::string name;
	float data;
};

class TableReaderExample:public TableReader
{

	std::list<DATA>* mList;
public:
	TableReaderExample(std::list<DATA>* _list):mList(_list){}

	virtual void readline(std::stringstream& _stream)
	{
		DATA data;
		_stream>>data.id>>data.name>>data.data;
		mList->push_back(data);
	}

};

std::string str("\n\n1\taaa\t1.2\n2\tbbb\t3.5");
std::list<DATA> list;
TableReaderExample example(&list);
bool ret = example.parseFromBuffer(str.c_str(),2);

*/

class TableReader
{

public:
	virtual bool parse(const std::string& filename, int jumplines = 0);
	bool parseFromBuffer(const char*, int jumplines = 0);
protected:
	virtual void readline(const std::string& line){};
	virtual void readline(std::stringstream& _stream){};
	virtual ~TableReader();
};

/**
Reader for lua
auto read a txt into string vectors.
seekLine means get line for line number start form 0
seekIndex means get line for index(which is the first row convert to integer)
all data got is a string. Which means it should be converted in lua logic
*/
class TableAutoReader : public TableReader
{
private:
	typedef std::vector<std::vector<std::string> > TABLE_MAP;
	TABLE_MAP mTable;
	std::map<int,int> mIdIndex;
	int mSeekedLine;
	int mCurrentIndex;
public:
	virtual bool parse(const std::string& filename, int jumplines = 0);
	int getLineCount();
	bool seekLine(int line);
	bool seekIndex(int index);
	bool hasRow(int row);
	const char* getDataInRow(int row);
	const char* getData(int line,int row);
	const char* getDataIndex(int index,int row);

	TableAutoReader():mSeekedLine(1){};
	virtual ~TableAutoReader();

protected:
	void readline(const std::string& str);


};

/*
*@desc:read xml file
*@author:liu longfei
*/
using namespace tinyxml2;
class XMLReader
{
public:
	virtual bool parse(const std::string& filename, int jumplines = 0);
protected:
	virtual void readline(XMLElement* e){};	
};

class TableReaderManager : public Singleton<TableReaderManager>
{
	std::map<std::string,TableAutoReader*> mTableReaders;
public:
	static TableReaderManager* getInstance(){return TableReaderManager::Get();}

	TableAutoReader* getTableReader(const char* filename);
	void reloadAllReader();
};
