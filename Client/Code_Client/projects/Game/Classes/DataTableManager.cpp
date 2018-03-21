#include "DataTableManager.h"

VaribleManager::~VaribleManager()
{
}

VaribleManager* VaribleManager::getInstance()
{
	return VaribleManager::Get();
}

void PlatformRoleTableManager::init(const std::string& filename)
{
	PlatformRoleList::iterator it = mPlatformRoleList.begin();
	while (it != mPlatformRoleList.end())
	{
		delete it->second;
		it->second = NULL;
		++it;
	}
	mPlatformRoleList.clear();
	parse(filename, 1);
}

const PlatformRoleItem * PlatformRoleTableManager::getPlatformRoleByID(unsigned int id)
{
	if (mPlatformRoleList.find(id) != mPlatformRoleList.end())
		return mPlatformRoleList.find(id)->second;
	return NULL;
}

const PlatformRoleItem * PlatformRoleTableManager::getPlatformRoleByName(std::string name)
{
	PlatformRoleList::iterator it = mPlatformRoleList.begin();
	for (; it != mPlatformRoleList.end(); ++it)
	{
		if (it->second)
		{
			if (it->second->name == name)
			{
				return it->second;
			}
		}
	}
	return NULL;
}

void PlatformRoleTableManager::readline(std::stringstream& _stream)
{
	PlatformRoleItem* item = new PlatformRoleItem;
	item->readline(_stream);
	mPlatformRoleList.insert(PlatformRoleList::value_type(item->id, item));
}

PlatformRoleTableManager* PlatformRoleTableManager::getInstance()
{
	return PlatformRoleTableManager::Get();
}