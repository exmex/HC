
#ifndef __BulletinBoardPage__h__
#define __BulletinBoardPage__h__

class BulletinBoardPageListener
{
public:
    virtual void onStartLoad(){};
    virtual void onFinishLoad(){};
    virtual void onFailLoadWithError(const std::string error){};
    virtual void onBtnAction(){};
    virtual void onLoadingTimeOut(){};
};

class BulletinBoardPage
{
public:
    void init(float left,float top, float width, float height, BulletinBoardPageListener *listener);

     static BulletinBoardPage* getInstance()
     {
         if(mInstance)
         {
             mInstance = new BulletinBoardPage;
         }
         return mInstance;
     }

    void close();
    void show(const std::string& url);
    void webKitSetLoadingTimeOut(int seconds);
private:
    static BulletinBoardPage* mInstance;
};


#endif
